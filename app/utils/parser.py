import json
import re

def parse_llm_response(response_data):
    try:
        if isinstance(response_data, dict):
            text_to_parse = response_data.get('response', '')
        else:
            text_to_parse = str(response_data)

        print("Teks yang akan diproses:", text_to_parse)

        clean_text = re.sub(r'```json|```', '', text_to_parse).strip()

        match = re.search(r'\{.*\}', clean_text, re.DOTALL)
        if match:
            clean_text = match.group(0)

        data = json.loads(clean_text)

        return data.get("compliments", [])

    except Exception as e:
        print(f"Gagal parsing: {e}")
        return []
