# Shopping Cart

## Description :book:
This app is the simulation of an e-commerce api that has a checkout endpoint by which is sent a payload with a list of products and it returns a response with the purchase resume. It includes the following features:
* Each product might have a discount which is returned by a gRPC service;
* When the discount service is not available, there aren't any discounts applied and the checkout endpoint keeps working;
* When it is Black Friday, it is added an extra product as a gift;
* Gifts are not available for sale;

This application does not use a database. The file `products.json` is used as the result of an api that is consulted for products information.

## Technologies 💻
This app was developed using:
* Ruby version 3.0.2
* Rails version 6.1.4.7

## How to run this application 🐳
You should have [Docker](https://docs.docker.com/engine/install/) installed.

1. Clone this app by running in your terminal:</br>
<pre>git clone git@github.com:camilamiz/shopping_cart.git</pre>
2. Access the app folder:
<pre>cd shopping_cart</pre>
3. In order to make the rails application and the discount service containers communicate, we will create a network that will be useb by both:
<pre>docker network create shopping-cart-network</pre>
4. We will now build the app image locally by running the command below, which will take a little while to finish.
<pre>docker-compose build</pre>
5. After the previous command finishes, run the command below to run the application:
<pre>docker-compose up</pre>
6. It will be necessary to get the ip address of the discount service to fill the .env file. So open another terminal window while the application is running and run the command below:
<pre>docker ps</pre>
It will return something like this:
![image](https://user-images.githubusercontent.com/39624192/159096160-58bead7f-7923-4fa9-840d-001b0fd1ef75.png)
7. Copy the container id of the hashorg/hash-mock-discount-service image and run the command below. It should return discount service's IPAddress, which will be na environment variable:
<pre>docker inspect <container-id> | grep IPAdddress </pre>
8. Make sure you are in the application's folder (`cd shopping_cart`) and run the command below, replacing "IPAddress" by the IPAddress from the previous step:
<pre>touch .env && echo DISCOUNT_SERVICE=IPAddress:50051 >> .env</pre>
9. Now return to the terminal window where docker is running, type `ctrl_c` to stop it and run `docker-compose up` again. The application is ready to be used.  

## Running the tests 📏
Open a new terminal window, access the app folder and run
<pre>bundle exec rspec --format documentation</pre>
The `--format documentation` command can be removed for less detailed test results.<br>
<i>I was not able to stub the gRPC request in the tests, even using grpc_mock gem. If someone knows how to do this using, please let me know.</i>

## How the API works ⚙️
Since for now we are running the app locally, we will use `http://locahost:3000` as the base url.
Using an API client like Insomnia, Postman, etc, there is available the following route:

### POST api/v1/checkout
This is an example of the parameters to be sent in the request's body:
```
{
    "products": [
	{
            "id": 1,
            "quantity": 3
        },
        {
            "id": 2,
            "quantity": 1
        }
    ]
}
```
If the request is sucessfull, it will return a status code of `200` and the shopping cart resume.
![image](https://user-images.githubusercontent.com/39624192/158282903-16ad40fd-030c-436c-bca8-ff96352874e8.png)

This is an example of a request that is sent with a product that should not be for sale:
![image](https://user-images.githubusercontent.com/39624192/159097548-67e6c4a7-b562-47f6-9b73-aa0dee50b9fa.png)


------------------------

This app was developed by [@camilamiz](https://github.com/camilamiz) 💜.
