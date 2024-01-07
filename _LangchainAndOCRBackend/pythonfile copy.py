from flask import Flask, request, jsonify
import os 

import requests
from PyPDF2 import PdfReader

os.environ["HUGGINGFACEHUB_API_TOKEN"] = "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"
# from langchain.document_loaders import TextLoader #for textfiles
from langchain.text_splitter import CharacterTextSplitter # text Splitter
from langchain.embeddings import HuggingFaceEmbeddings #for using HuggingFace Models
# Vectorstore: https://python.langchain.com/en/latest/modules/indexes/vectorstores.html
from langchain.vectorstores import FAISS #facebook vectorization langchain.chains.question_answering import load_qa_chain
from langchain.chains.question_answering import load_qa_chain
from langchain import HuggingFaceHub
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationalRetrievalChain
from langchain.document_loaders import UnstructuredPDFLoader #load pdf
from langchain.indexes import VectorstoreIndexCreator #vectorize db index with chromadb
from langchain.chains import RetrievalQA
from langchain.document_loaders import UnstructuredURLLoader #load
from langchain.prompts import PromptTemplate
pdf_file_paths = ["D:\Pdflang\pdf.pdf"]

def get_pdf_text(pdf_docs):
    text = ""
    for pdf in pdf_docs:
        pdf_reader = PdfReader(pdf)
        for page in pdf_reader.pages:
            text += page.extract_text()
    return text

def get_text_chunks(text):
    text_splitter = CharacterTextSplitter(separator = '\n', chunk_size = 1000, chunk_overlap = 50, length_function = len)
    chunks = text_splitter.split_text(text)
    return chunks

def get_vectorstore(text_chunks):
    embeddings = HuggingFaceEmbeddings()
    vectorstore = FAISS.from_texts(text_chunks, embeddings)
    return vectorstore

def get_conversation_chain(vectorstore):
    repo_id = "declare-lab/flan-alpaca-large"
    # repo_id = "google/flan-t5-base"
    
    llm = HuggingFaceHub(repo_id = repo_id, model_kwargs = {"temperature":0.9,"max_length":500})
    prompt_template = """Use the following pieces of context to answer the question at the end. If you don't know the answer, just say that you don't know, don't try to make up an answer. If the question is out of context, just strictly say that you don't know , don't try to make up an answer.
    Only use the pieces of context to answer the question at the end. If the question is out of context say that you don't know the answer or you couldn't find the answer in the PDF document.
    
    {context}

    Question: {question}
    Helpful Answer:"""
    PROMPT = PromptTemplate(
    template=prompt_template, input_variables=["context", "question"]
    )

    chain_type_kwargs = {"prompt": PROMPT}
    chain = RetrievalQA.from_chain_type(llm = llm, chain_type="stuff", retriever= vectorstore.as_retriever(search_type = "similarity",search_kwargs={"k":6}, score_threshold=0.75), input_key = "question",chain_type_kwargs=chain_type_kwargs)
    return chain

app = Flask(__name__)

# Endpoint to receive PDF from flutter apps
@app.route('/upload', methods=['POST'])
def upload_pdf():
    print("uploaded")
    if 'pdf' not in request.files:
        return 'No PDF file uploaded', 400

    pdf_file = request.files['pdf']
    if pdf_file.filename == '':
        return 'No selected file', 400

    pdf_file.save("./"+ "pdf.pdf")
    raw_text = get_pdf_text(pdf_file_paths)

# Split the text into chunks
    text_chunks = get_text_chunks(raw_text)

# Create the vector store
    vectorstore = get_vectorstore(text_chunks)

# Create the conversation chain
    global chain
    chain = get_conversation_chain(vectorstore)
    print('I ran too')
    return 'PDF file uploaded successfully'   
    
# Endpoint to receive question from Flutter app
@app.route('/ask_question', methods=['POST'])
def ask_question():
    if request.method == 'POST':
        question = request.json.get('question')
        user_question = question 
        responseer = chain({"question": user_question})
        print("Response:", responseer)
        # Check if the question is valid
        if question:
            # response = chain({"question": question})
            # answer = response.get('answer',response)
            
            return responseer #Got me a lot of head wrapping. It is already in json format
        else:
            return jsonify({'error': 'Invalid question'}), 400

# Endpoint for other functionalities or additional routes

if __name__ == '__main__':
    # Run the Flask app
    app.run(host='0.0.0.0', port=9000)