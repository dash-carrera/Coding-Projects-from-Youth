#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import webapp2
import httplib, urllib
import sys
import random, string

first_player_authenticated = False #false while the first player has not registered
second_player_authenticated = False

p1score = 10
p2score = 10


first_player_id = 0
second_player_id = 0
payment_amount = .01

def get_id(auth_id):
	#Gets the 'id' number of a user based on the 'authentication id'
	first_conn = httplib.HTTPSConnection("api.venmo.com/v1/me")
	first_conn.request("GET", "?access_token=" + str(auth_id))
	returned_json = str(first_conn.getresponse().read())
	receiver_id = returned_json.split("id\":")[1].split(",")[0][2:-1]
	print >>sys.stderr, receiver_id
	return receiver_id

def pay(sender, receiver, amount, note):
	#Makes a payment, given two authentication ids
	print >>sys.stderr, sender
	random_string = ''.join(random.choice(string.ascii_uppercase + string.digits) for x in range(5))
	params = urllib.urlencode({'access_token':sender, 'user_id':get_id(receiver), 'amount':amount, 'note':random_string})
	headers = {"Content-type": "application/x-www-form-urlencoded",
		            "Accept": "text/plain"}
	conn = httplib.HTTPSConnection("api.venmo.com/v1/payments")
	conn.request("POST", "", params, headers)
	response = conn.getresponse()
	conn.close()
	return response.read()

class MainPage(webapp2.RequestHandler):
	#Generate the page based on the variables
	global first_player_authenticated, second_player_authenticated
	def get(self):
		if (first_player_authenticated):
			self.response.write("First Player Registered<br>")
		else:
			self.response.write('''<form method="get" action="/request-authentication1">
			    <button type="submit">Authenticate Player 1</button>
			</form>''')
		if (second_player_authenticated):
			self.response.write("Second Player Registered<br>")
		else:
			self.response.write('''<form method="get" action="/request-authentication2">
			    <button type="submit">Authenticate Player 2</button>
			</form>''')

		if (first_player_authenticated and second_player_authenticated):
			self.response.write('''<form method="get" action="/reset">
			    <button type="submit">New Game</button>
			</form>''')

class RequestAuthentication1(webapp2.RequestHandler):
	def get(self):
		self.redirect("https://api.venmo.com/v1/oauth/authorize?client_id=1577&scope=make_payments%20access_profile&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Fvenmo_oauth%3Fplayer%3D1")

class RequestAuthentication2(webapp2.RequestHandler):
	def get(self):
		self.redirect("https://api.venmo.com/v1/oauth/authorize?client_id=1577&scope=make_payments%20access_profile&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Fvenmo_oauth%3Fplayer%3D2")


class Authentication(webapp2.RequestHandler):
	def get(self):
		#self.response.write(get_id(self.request.get("access_token")))
		global first_player_authenticated, second_player_authenticated, first_player_id, second_player_id
		player = int(self.request.get("player"))
		if player == 1:
			first_player_id = str(self.request.get("access_token"))
			first_player_authenticated = True
		elif player == 2:
			second_player_id = str(self.request.get("access_token"))
			second_player_authenticated = True
		self.redirect("http://localhost:8080")


class MakePayment(webapp2.RequestHandler):
	def get(self):
		global first_player_id, second_player_id
		winner = int(self.request.get("winner"))
		if winner == 1:
			pay(second_player_id, first_player_id, payment_amount, "blablabla")
		elif winner == 2:
			pay(first_player_id, second_player_id, payment_amount, "blablabla")

class Reset(webapp2.RequestHandler):
	def get(self):
		global first_player_authenticated, second_player_authenticated
		first_player_authenticated = False
		second_player_authenticated = False
		self.redirect("http://localhost:8080")

class GetScore(webapp2.RequestHandler):
	#Gets the current score for the user
	def get(self):
		self.response.write(str(p1score)+"&"+str(p2score))

class UpdateScore(webapp2.RequestHandler):
	#Updates the score given a post request from Processing
	def get(self):
		global p1score, p2score
		p1score = self.request.get("p1score")
		p2score = self.request.get("p2score")

application = webapp2.WSGIApplication([
   ('/', MainPage),
    ('/venmo_oauth',Authentication),
    ('/payment',MakePayment),
    ('/reset',Reset),
    ('/request-authentication1', RequestAuthentication1),
    ('/request-authentication2', RequestAuthentication2),
    ('/get-score',GetScore),
    ('/update-score', UpdateScore)
], debug=True)