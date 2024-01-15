import unittest
import requests_mock

from frontend import app

class FlaskAppTestCase(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_home(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

    @requests_mock.mock()
    def test_handle_registration(self, m):
        m.post('http://user:5001/register', text='success')
        response = self.app.post('/register', data={'username': 'testuser', 'password': 'testpass'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'success', response.data)

    @requests_mock.mock()
    def test_handle_login(self, m):
        m.post('http://user:5001/login', text='login successful')
        response = self.app.post('/login', data={'username': 'testuser', 'password': 'testpass'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'login successful', response.data)

    @requests_mock.mock()
    def test_store_data(self, m):
        m.post('http://data:5002/store', text='data stored')
        response = self.app.post('/store', data={'user': 'testuser', 'message': 'test message'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'data stored', response.data)

if __name__ == '__main__':
    unittest.main()
