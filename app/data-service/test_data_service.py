import unittest
import json
from data import app, db, Data


class DataServiceTestCase(unittest.TestCase):
    def setUp(self):
        # Set up the Flask test client
        self.app = app.test_client()
        # Set up the app context for the tests
        app.config["TESTING"] = True
        app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
        with app.app_context():
            # Create all tables in memory
            db.create_all()

    def tearDown(self):
        with app.app_context():
            # Drop all tables
            db.session.remove()
            db.drop_all()

    def test_store_data(self):
        # Test storing data
        response = self.app.post(
            "/store",
            data=json.dumps({"user": "testuser", "message": "Hello World"}),
            content_type="application/json",
        )
        self.assertEqual(response.status_code, 201)
        self.assertIn("Data stored", response.get_json()["message"])

    def test_retrieve_data(self):
        # First, store some data
        self.app.post(
            "/store",
            data=json.dumps({"user": "testuser", "message": "Hello World"}),
            content_type="application/json",
        )

        # Then retrieve it
        response = self.app.get("/retrieve", query_string={"user": "testuser"})
        self.assertEqual(response.status_code, 200)
        data = response.get_json()["data"]
        self.assertIn("Hello World", data)


if __name__ == "__main__":
    unittest.main()
