import jwt
import os
from datetime import datetime, timezone, timedelta
from werkzeug.security import generate_password_hash, check_password_hash
from app.extensions import SessionLocal
from app.models.user import User


SECRET_KEY = os.getenv("SECRET_KEY", "changeme-secret-key")


def register_user(name: str, email: str, password: str):
    session = SessionLocal()
    try:
        existing = session.query(User).filter_by(email=email).first()
        if existing:
            raise ValueError("Email sudah terdaftar")

        hashed = generate_password_hash(password)
        user = User(name=name, email=email, password=hashed)
        session.add(user)
        session.commit()

        return {
            "id": user.id,
            "name": user.name,
            "email": user.email,
        }
    except Exception as e:
        session.rollback()
        raise e
    finally:
        session.close()


def login_user(email: str, password: str):
    session = SessionLocal()
    try:
        user = session.query(User).filter_by(email=email).first()
        if not user or not check_password_hash(user.password, password):
            raise ValueError("Email atau password salah")

        payload = {
            "user_id": user.id,
            "email": user.email,
            "exp": datetime.now(timezone.utc) + timedelta(hours=24),
        }
        token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

        return {
            "token": token,
            "user": {
                "id": user.id,
                "name": user.name,
                "email": user.email,
            },
        }
    finally:
        session.close()
