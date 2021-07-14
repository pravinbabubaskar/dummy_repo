

Project Summery https://docs.google.com/presentation/d/1hJ53NAqaEStBWPl9hN-9YowMo643M0pHC--jwTLtGVU/edit?usp=sharing

ABSTRACT:

   While going throw sustainable goals 2021, we found eliminating
poverty ,erase hunger which should be solved immediately and its one of the
major concerns in developing counties like INDIA .Main reason for this problem
is lack of money and wasting unused excess food .So we thought to develop an
application which allows restaurant to give excess food at certain discounts and
also for free to verified NGO where they can donate it to needy.
Main idea behind our app is to reduce food waste in restaurants
and hotel and provide this food to people who can’t afford them via NGOs
and charities for free .And also we trying to build a fundraising module which
enables normal user to donate money to NGO
Technologies used to develop our mobile application which will be
supported in both android and iOS platforms
• Flutter
• Web Scrapping
• Neural Networks
• Google API
• Firebase

INTRODUCTION

   Aim of the project is to reduce the food wastage by developing an
application which allows restaurant to provide excess food at certain discounts
and also for free to verified NGO where they can donate it to needy .
TERMINOLOGIES AND PLATFORMS 

FLUTTER
 
   Flutter is an open-source UI software development tool developed
by Google which is a simple and high performance framework based on the
Dart language. It is used to develop applications for Mac, Android, Linux,iOS,
Windows, and the web from a single codebase.Flutter provides
• Beautiful and fluid user interfaces.
• High performance
• Modern and reactive framework.
• Fast development. 


COLAB

   Google Colab is a free notebook environment which runs entirely
in the cloud environment and it is a powerful platform for learning and quickly
developing machine learning models in Python and also for data analytics.Colab
supports many popular ML libraries such as PyTorch, TensorFlow, Keras and
OpenCV.


SOFTWARE STACK

FIREBASE

   Firebase is a real-time cloud-hosted database developed by Google
for creating mobile and web applications. Data is stored as JSON and synchronized
in realtime to every connected client.

DART

   Dart is a programming language developed by Google designed for
client development,such as web and mobile apps.And also used to build server
and desktop applications.It is an object-oriented, class-based language with C-style
syntax. Dart can compile to either native code or JavaScript. It supports interfaces,
mixins, abstract classes,and type inference etc.


GOOGLE API

   Google APIs are application programming interfaces (APIs) developed
by Google which provide communication with the Google Services and their
integration to other services.Third-party apps can use these APIs to take advantage
or to extend the functionality of the existing services.

RNN(LSTM)

   Long short-term memory (LSTM) is an artificial recurrent neural
network (RNN) architecture used in the field of deep learning. LSTM networks
are well-suited to classifying, processing and making predictions based on time
series data, since there can be lags of unknown duration between important
events in a time series.

WEB SCRAPPING

   Web Scrapping is an automatic method to obtain large amounts of
data from websites. Most of this data is unstructured data in an HTML format
which is then converted into structured data in a spreadsheet or a database so that
it can be used in various applications. There are many different ways to perform
web scraping to obtain data from websites. these include using online services,
particular API’s or even creating your code for web scraping from scratch


SYSTEM DESIGN

USER AUTHENTICATION

   Login/Sign-up the user will be authenticated using mail id and the
password.During Sign-up the mail id of the new user is verified using OTP first
before enter the sign-up details.

RESTAURANTS

   After login, all the nearby restaurants will be displayed based on the
location of the user with the estimated arrival time on the home screen. And In
Explore section all the restaurants registered in our application will be displayed.
the user can also search all the particular restaurants they want.

FOOD ORDERING

  After selecting the restaurant all the dishes provided by the restaurant
will be displayed from which the user will add dishes to the cart and also
provides the location and contact of the restaurant.

UPGRADE NGO
    In this module, the user will be upgraded to the NGO by entering
the name of the NGO which will be autheticated using web scrapping. After
NGO upgrade the restaurant will provide the dishes for free and they also get
donations from other users.

RESTAURANT BILL

   The user will be directed to the billing after adding the dishes to the
cart. The user will be able to pay the bill only through an online payment. After
payment, the timer for 10 seconds will be started after that your order will be
placed and a QR code will be generated .

ORDERS

  In this module user can check all their active and past orders.In active
orders all the current orders details and its QR code is displayed which is used
while picking order from restaurant.In past order all the cancelled and completed
orders will be displayed.

DONATION

  In this module the user will be able to donate money to NGO.the list
of NGO’s will be provided So the user can select a NGO and donate them.This
module helps the NGO to get donation from our app users in addition to the free
food provided by the restaurant.

TIME SERIES PREDICTION
   This module which uses tflite converted LSTM model to predict unused
food for the next 7 days based on food wasted for the past 3 days which act as
an input .We also get averages estimate of unused food quantity for next 7 days.

HOTEL AUTHENTICATION

  In login the restaurant admin has been authenticated using Login-id
and password.The new hotel will be registered by providing the details like
name,password ,restaurant type,address etc.

ORDER DETAILS

  All customer order details will be shown in this module.All the confirmed
orders details received from the customer will be shown in Active orders which
a QR scanner to verify user and In past order all the completed order details will
be displayed.

FOOD ANALYSIS

   This module provides two graphical representation(bar chart and line
chart).Bar chart represent the amount of excess food currently remaining in that
particular day.Line chart represents the excess food cooked by the restaurant for
the past 30 days.

PRODUCTS

   The restaurant will add dishes by adding the details like image, name,
id, price, description etc.which will be shown in the customer side.

RESTAURANT DETAILS

   This module provides the details of the restaurant which is provided
during Sign-up and provide upgrade profile option to add contact and email id
of the restaurant.
# Feed_The_Need
