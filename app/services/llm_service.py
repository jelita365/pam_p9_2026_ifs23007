# import requests
# from app.config import Config

# def generate_from_llm(prompt: str):
#     response = requests.post(
#         f"{Config.BASE_URL}/llm/chat",
#         json={
#             "token": Config.LLM_TOKEN,
#             "chat": prompt
#         }
#     )
    
#     # Debug Output dari API LLM
#     # print("STATUS:", response.status_code)
#     # print("RESPONSE:", response.text)

#     if response.status_code != 200:
#         raise Exception("LLM request failed")

#     return response.json()

import requests
from app.config import Config

def generate_from_llm(prompt: str):
    api_key = Config.LLM_TOKEN
    
    # Menggunakan endpoint resmi Google Gemini 1.5 Flash
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    
    # Format JSON payload yang diwajibkan oleh Google
    payload = {
        "contents": [
            {
                "parts": [
                    {"text": prompt}
                ]
            }
        ]
    }
    
    headers = {
        "Content-Type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers)
    
    # Debug jika terjadi error dari sisi Google
    if response.status_code != 200:
        print("ERROR DARI GEMINI:", response.text)
        raise Exception("Google Gemini API request failed")

    data = response.json()
    
    try:
        # Menelusuri hasil JSON dari Gemini untuk mendapatkan teks jawabannya
        answer_text = data["candidates"][0]["content"]["parts"][0]["text"]
        
        # Mengembalikan dalam format yang dikenali oleh parser.py Anda
        return {"response": answer_text}
        
    except (KeyError, IndexError) as e:
        raise Exception(f"Gagal membaca format response Gemini: {str(e)}")

# from google import genai
# from google.genai import types # Tambahkan import ini
# from app.config import Config

# def generate_from_llm(prompt: str):
#     api_key = Config.LLM_TOKEN
#     if not api_key:
#         raise Exception("API Key tidak ditemukan di .env")

#     clean_key = api_key.replace('"', '').replace("'", "").strip()
    
#     # Tambahkan konfigurasi http_options untuk memaksa versi API v1
#     client = genai.Client(
#         api_key=clean_key,
#         http_options={'api_version': 'v1'} 
#     )

#     try:
#         # Gunakan model 'gemini-1.5-flash'
#         response = client.models.generate_content(
#             model="gemini-1.5-flash", 
#             contents=prompt
#         )
        
#         if not response.text:
#             raise Exception("Gemini mengembalikan respons kosong")
            
#         return {"response": response.text}
        
#     except Exception as e:
#         print("ERROR DARI GOOGLE GENAI:", str(e))
#         # Jika masih 404, kita akan mencoba model gemini-1.5-pro sebagai cadangan terakhir
#         raise Exception(f"Gagal generate data dari Gemini API: {str(e)}")