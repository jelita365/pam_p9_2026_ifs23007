# Compliment Generator API

Backend Flask API untuk generate kalimat pujian menggunakan Google Gemini AI.

## Setup

1. Clone repo dan masuk ke folder:
   ```bash
   cd compliment-be
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Salin `.env.example` ke `.env` dan isi API key:
   ```bash
   cp .env.example .env
   ```

4. Jalankan aplikasi:
   ```bash
   python app.py
   ```

## Endpoints

### POST `/compliments/generate`
Generate kalimat pujian baru.

**Body:**
```json
{
  "theme": "semangat belajar",
  "total": 5
}
```

**Response:**
```json
{
  "theme": "semangat belajar",
  "total": 5,
  "data": ["...", "..."]
}
```

### GET `/compliments?page=1&per_page=10`
Ambil semua pujian yang sudah tersimpan dengan pagination.
