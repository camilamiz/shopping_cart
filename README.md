# Shopping Cart

## Description :book:
This app is the simulation of an e-commerce api that has a checkout endpoint, by which is sent a payload with a list of products and it returns a response with the purchase resume. It includes the following features:
* Each product might have a discount which is returned by a grpc service
* When the discount service is not available, there aren't any discounts applied and the checkout endpoint keeps working
* When it is Black Friday, it is added an extra product as a gift

## Technologies 💻
This app was developed using:
* Ruby version 3.0.2
* Rails version 6.1.4.7

## How to run this application 🐳
1. Clone this app by running in your terminal</br>
<pre>git clone git@github.com:camilamiz/shopping_cart.git</pre>
2. Access the app folder
<pre>cd shopping_cart</pre>
3. For this step you should have [Docker](https://docs.docker.com/engine/install/) installed. In order to build the app image locally, run the command below, which will take a little while to finish.
<pre>docker-compose up web discount</pre>
4. If you want to kill it, type `ctrl+c` in your terminal window


## Running the tests 📏
With the application running, open a new terminal window, access the app folder and run
<pre>docker run shopping_cart bundle exec rspec --format documentation</pre>
The `--format documentation` command can be removed for less detailed test results.

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
            "quantity": 1
        }
    ]
}
```
If the request is sucessfull, it will return a status code of `200` and the created partner.
![image](https://user-images.githubusercontent.com/39624192/132991411-d2eb43c9-9754-4510-995b-a2bcc176ddcf.png)

If the request is successfull, the status code will be `200` and the response will bring the following fields:
* The location is inside the coverage area of the closest partner (`inside_coverage_area` is `true` or `false`)
* The distance of the closest partner to the location in km (`distance_in_km`)
* The closest partner that was found in the list (`closest_partner`)

![image](https://user-images.githubusercontent.com/39624192/132991450-324b9293-4ec0-47c9-9501-d6391db1975a.png)


------------------------

This app was developed by [@camilamiz](https://github.com/camilamiz) 💜.
