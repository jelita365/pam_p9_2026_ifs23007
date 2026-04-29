from flask import Blueprint, request, jsonify
from app.services.compliment_service import (
    create_compliments,
    get_all_compliments
)
from app.utils.auth_middleware import token_required

compliment_bp = Blueprint("compliment", __name__)

@compliment_bp.route("/", methods=["GET"])
def index():
    return "API telah berjalan!"


@compliment_bp.route("/compliments/generate", methods=["POST"])
@token_required
def generate():
    data = request.get_json()
    theme = data.get("theme")
    total = data.get("total")

    if not theme:
        return jsonify({"error": "Theme is required"}), 400

    if not total:
        return jsonify({"error": "Total is required"}), 400

    if total <= 0:
        return jsonify({"error": "Total harus besar dari 0"}), 400

    if total > 10:
        return jsonify({"error": "Total maksimal harus 10"}), 400

    try:
        result = create_compliments(theme, total)
        return jsonify({
            "theme": theme,
            "total": len(result),
            "data": result
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@compliment_bp.route("/compliments", methods=["GET"])
@token_required
def get_all():
    page = request.args.get("page", default=1, type=int)
    per_page = request.args.get("per_page", default=100, type=int)

    data = get_all_compliments(page=page, per_page=per_page)

    return jsonify(data)
