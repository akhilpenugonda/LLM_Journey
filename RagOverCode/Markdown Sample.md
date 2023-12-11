# Chat with PDF 💬

This code is for a user interface that allows the user to upload a PDF file, ask questions about the file, and get answers based on the content of the PDF.

## `main()` function

The main function is the entry point of the code. It starts by displaying a header titled "Chat with PDF 💬".

Next, the user is prompted to upload a PDF file using the `st.file_uploader("Upload your PDF", type='pdf')` function. The file uploader only accepts PDF files.

If the user has uploaded a PDF file, the code proceeds to read the contents of the PDF using the `PdfReader()` function from the `PyPDF2` library. The contents of each page are extracted and concatenated into a single string variable `text`.

The `RecursiveCharacterTextSplitter()` function is then used to split the `text` into chunks. This function splits the text into smaller chunks based on the specified chunk size and overlap. The purpose of splitting the text into chunks is to process them separately and improve the efficiency of similarity search.

The code checks if embeddings for the PDF file already exist by looking for a `.pkl` file with the same name as the PDF file. If the embeddings file exists, it is loaded from the disk using the `pickle.load()` function. If the embeddings file does not exist, the code proceeds to create embeddings for the chunks of text using the `OpenAIEmbeddings()` function. The embeddings are then stored in a `VectorStore` object using the `FAISS.from_texts()` function. The `VectorStore` object is then saved to the disk in a `.pkl` file using the `pickle.dump()` function.

After the embeddings have been loaded or created, the code prompts the user to enter a question about the PDF file using the `st.text_input("Ask questions about your PDF file:")` function. The user's input is stored in the `query` variable.

If the user has entered a question, the code performs a similarity search in the `VectorStore` using the `similarity_search()` method. The method takes the user's query and the number of similar documents to retrieve as input parameters. The method returns a list of documents that are similar to the query, ranked by similarity.

The code then uses either the `OpenAI()` or `GooglePalm()` language model to generate an answer to the user's question based on the retrieved similar documents. The choice of language model can be configured by uncommenting the appropriate line of code. The `OpenAI()` language model is initialized with a temperature of 0.0, which means it will always generate the same output for the same input. The model is set to "davinci-002", but this can be changed to a different model if desired.

Finally, the code runs the question-answer generation process using the `run()` method of the QA chain. The method takes the retrieved similar documents and the user's query as input and generates a response. The response is then displayed using the `st.write()` function.

Note: It is not clear what the purpose of the `get_openai_callback()` function is, as it is not defined in the code provided. The code includes a comment `print(cb)` after calling the `chain.run()` method, which suggests that the `cb` variable might be the result of the `get_openai_callback()` function. However, since the function is not defined, the behavior is unknown.