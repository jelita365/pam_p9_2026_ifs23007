from app.extensions import SessionLocal
from app.models.compliment import Compliment
from app.models.request_log import RequestLog
from app.services.llm_service import generate_from_llm
from app.utils.parser import parse_llm_response

def create_compliments(theme: str, total: int):
    session = SessionLocal()

    try:
        prompt = f"""
        Berikan jawaban dalam format JSON saja.
        Buat {total} kalimat pujian bertema "{theme}".
        Format:
        {{
            "compliments": [
                {{"text": "Kalimat pujian di sini"}}
            ]
        }}
        """

        result = generate_from_llm(prompt)
        compliments = parse_llm_response(result)

        req_log = RequestLog(theme=theme)
        session.add(req_log)
        session.commit()

        saved = []

        for item in compliments:
            compliment_text = item.get("text")

            m = Compliment(
                text=compliment_text,
                theme=theme,
                request_id=req_log.id
            )
            session.add(m)
            saved.append(compliment_text)

        session.commit()

        return saved

    except Exception as e:
        session.rollback()
        raise e

    finally:
        session.close()


def get_all_compliments(page: int = 1, per_page: int = 100):
    session = SessionLocal()

    try:
        query = session.query(Compliment)

        total = query.count()

        data = (
            query
            .order_by(Compliment.id.desc())
            .offset((page - 1) * per_page)
            .limit(per_page)
            .all()
        )

        result = [
            {
                "id": m.id,
                "text": m.text,
                "theme": m.theme,
                "created_at": m.created_at.isoformat()
            }
            for m in data
        ]

        return {
            "page": page,
            "per_page": per_page,
            "total": total,
            "total_pages": (total + per_page - 1) // per_page,
            "data": result
        }

    finally:
        session.close()
