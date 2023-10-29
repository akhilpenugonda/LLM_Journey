// import { OpenAI } from "langchain/llms/openai";
// import { ChatOpenAI } from "langchain/chat_models/openai";
// // import GooglePalmEmbeddings from langchain.embeddings 
// import GooglePalm from "langchain/llms/googlepalm"
// // const llm = new OpenAI({
// //   temperature: 0.9,
// // });
// let llm = GooglePalm()
// llm.temperature = 0.1

// prompts = ["The opposite of hot is",'The opposite of cold is'] 
// let llm_result = llm._generate(prompts)

// llm_result.generations[0][0].text
// llm_result.generations[1][0].text


// // const chatModel = new ChatOpenAI();

// // const text =
// //   "What would be a good company name for a company that makes colorful socks?";

// // const llmResult = await llm.predict(text);
// // /*
// //   "Feetful of Fun"
// // */

// // const chatModelResult = await chatModel.predict(text);
// // /*
// //   "Socks O'Color"
// // */

import {GooglePaLM} from "langchain/llms/googlepalm"


const input = {
  modelName: 'models/text-bison-001',
  temperature: 0.1,
  max_output_tokens: 1000,
  topP: 0.9,
  topK: 3,
  stopSequences: ['.', '?', '!'],
  safetySettings: [
    {
      category: 'IDENTITY',
      threshold: 0.5,
    },
    {
      category: 'PROFANITY',
      threshold: 0.8,
    },
  ],
  apiKey: 'AIzaSyDYTaObtIda0gQKytXUpWlDU0AsPSR4Gvo',
  //'AIzaSyD3d3npOFWRAbYPaKP1Yk8KWhGyiHtumZM',
};

// Create an instance of GooglePaLM
const llm = new GooglePaLM(input);

let prompts = ['Write DFS Program for Binary Tree'] 
let llm_result = await llm._generate(prompts).then((result) => {
    console.log(result.generations[0][0].text);
    }
);
