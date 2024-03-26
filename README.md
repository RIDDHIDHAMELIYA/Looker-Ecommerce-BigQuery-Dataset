# Looker-Ecommerce-BigQuery-Dataset
### E-commerce Data Analysis with Dashboard

## Dataset in BigQuery

TheLook is a fictitious eCommerce clothing site developed by the Looker team. The dataset contains information >about customers, products, orders, logistics, web events and digital marketing campaigns. The contents of this >dataset are synthetic, and are provided to industry practitioners for the purpose of product discovery, testing, and >evaluation.
This public dataset is hosted in Google BigQuery and is included in BigQuery's 1TB/mo of free tier processing. This >means that each user receives 1TB of free BigQuery processing every month, which can be used to run queries on >this public dataset. Watch this short video to learn how to get started quickly using BigQuery to access public >datasets.

1. distribution_centers.csv
Columns:
id: Unique identifier for each distribution center.
name: Name of the distribution center.
latitude: Latitude coordinate of the distribution center.
longitude: Longitude coordinate of the distribution center.

2. events.csv
Columns:
id: Unique identifier for each event.
user_id: Identifier for the user associated with the event.
sequence_number: Sequence number of the event.
session_id: Identifier for the session during which the event occurred.
created_at: Timestamp indicating when the event took place.
ip_address: IP address from which the event originated.
city: City where the event occurred.
state: State where the event occurred.
postal_code: Postal code of the event location.
browser: Web browser used during the event.
traffic_source: Source of the traffic leading to the event.
uri: Uniform Resource Identifier associated with the event.
event_type: Type of event recorded.

3. inventory_items.csv
Columns:
id: Unique identifier for each inventory item.
product_id: Identifier for the associated product.
created_at: Timestamp indicating when the inventory item was created.
sold_at: Timestamp indicating when the item was sold.
cost: Cost of the inventory item.
product_category: Category of the associated product.
product_name: Name of the associated product.
product_brand: Brand of the associated product.
product_retail_price: Retail price of the associated product.
product_department: Department to which the product belongs.
product_sku: Stock Keeping Unit (SKU) of the product.
product_distribution_center_id: Identifier for the distribution center associated with the product.

4. order_items.csv
Columns:
id: Unique identifier for each order item.
order_id: Identifier for the associated order.
user_id: Identifier for the user who placed the order.
product_id: Identifier for the associated product.
inventory_item_id: Identifier for the associated inventory item.
status: Status of the order item.
created_at: Timestamp indicating when the order item was created.
shipped_at: Timestamp indicating when the order item was shipped.
delivered_at: Timestamp indicating when the order item was delivered.
returned_at: Timestamp indicating when the order item was returned.

5. orders.csv
Columns:
order_id: Unique identifier for each order.
user_id: Identifier for the user who placed the order.
status: Status of the order.
gender: Gender information of the user.
created_at: Timestamp indicating when the order was created.
returned_at: Timestamp indicating when the order was returned.
shipped_at: Timestamp indicating when the order was shipped.
delivered_at: Timestamp indicating when the order was delivered.
num_of_item: Number of items in the order.

6. products.csv
Columns:
id: Unique identifier for each product.
cost: Cost of the product.
category: Category to which the product belongs.
name: Name of the product.
brand: Brand of the product.
retail_price: Retail price of the product.
department: Department to which the product belongs.
sku: Stock Keeping Unit (SKU) of the product.
distribution_center_id: Identifier for the distribution center associated with the product.

7. users.csv
Columns:
id: Unique identifier for each user.
first_name: First name of the user.
last_name: Last name of the user.
email: Email address of the user.
age: Age of the user.
gender: Gender of the user.
state: State where the user is located.
street_address: Street address of the user.
postal_code: Postal code of the user.
city: City where the user is located.
country: Country where the user is located.
latitude: Latitude coordinate of the user.
longitude: Longitude coordinate of the user.
traffic_source: Source of the traffic leading to the user.
created_at: Timestamp indicating when the user account was created.

### Potential Analyses:

**Geospatial Analysis:**
Utilize distribution_centers.csv and users.csv for mapping and analyzing the geographic distribution of users and distribution centers.

**User Behavior Analysis:**
Use events.csv to analyze user behavior, including session patterns, traffic sources, and event types.

**Sales and Revenue Analysis:**
Leverage order_items.csv and inventory_items.csv to analyze product sales, revenue, and profitability.

**Product Performance Analysis:**
Explore products.csv to analyze product performance, including costs, categories, and popularity.

**User Demographics Analysis:**
Use users.csv to analyze user demographics, such as age, gender, and location.

**Order Fulfillment Analysis:**
Analyze order_items.csv and orders.csv to understand order fulfillment timelines and status.

> These analyses provide insights into user engagement, product performance, and overall e-commerce operations, aiding in strategic decision-making and business optimization.

### Data source: https://www.kaggle.com/datasets/mustafakeser4/looker-ecommerce-bigquery-dataset/data
### Here is my Looker Dashboard: https://lookerstudio.google.com/reporting/1068c6cb-c557-4688-b0b2-8c39702b5064/page/MPctD
> ⚠️ Due to the large files I haven't Uploaded all the data, you may need to download data from Kaggle or BigQuery. 

**Install the virtual environment and the required packages by following commands:**
```BASH
pyenv local 3.11.3
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

