import unittest
import json
from user import app, db, User

class UserServiceTestCase(unittest.TestCase):

    def setUp(self):
        # Set up a test client and create a test environment
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'  # Use in-memory database for testing
        self.app = app.test_client()
        with app.app_context():
            db.create_all()

    def tearDown(self):
        # Tear down the test environment after each test
        with app.app_context():
            db.session.remove()
            db.drop_all()

    def test_user_registration(self):
        # Test user registration
        response = self.app.post('/register', json={'username': 'testuser', 'password': 'testpassword'})
        self.assertEqual(response.status_code, 201)
        self.assertIn('User registered', response.get_json()['message'])

    def test_duplicate_user_registration(self):
        # Test registration with a duplicate username
        self.app.post('/register', json={'username': 'testuser', 'password': 'testpassword'})
        response = self.app.post('/register', json={'username': 'testuser', 'password': 'testpassword'})
        self.assertEqual(response.status_code, 409)
        self.assertIn('User already exists', response.get_json()['message'])

    def test_user_login(self):
        # Test user login
        self.app.post('/register', json={'username': 'testuser', 'password': 'testpassword'})
        response = self.app.post('/login', json={'username': 'testuser', 'password': 'testpassword'})
        self.assertEqual(response.status_code, 200)
        self.assertIn('Logged in successfully', response.get_json()['message'])

    def test_invalid_login(self):
        # Test login with invalid credentials
        response = self.app.post('/login', json={'username': 'wronguser', 'password': 'wrongpassword'})
        self.assertEqual(response.status_code, 401)
        self.assertIn('Invalid credentials', response.get_json()['message'])

if __name__ == '__main__':
    unittest.main()
