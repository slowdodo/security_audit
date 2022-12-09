import json
import mysql.connector
import requests
import sys
import random
import concurrent.futures



def generate_public_ip():
    octet1 = random.randint(1, 223)
    octet2 = random.randint(1, 255)
    octet3 = random.randint(1, 255)
    octet4 = random.randint(1, 255)
    return str(octet1) + "." + str(octet2) + "." + str(octet3) + "." + str(octet4)
    

def api(ip):
    url = "https://api.criminalip.io/v1/ip/summary?ip={ip}".format(ip=ip)
    api_key = "cQKzaOREwe9xxBMNtrNv0popkOqaI1EFMqKmubVQaLiNSPerRAlqFDxZ8QeL"


    # Send the API request
    payload = {}
    headers = {
        "x-api-key": api_key
    }

    response = requests.request("GET", url, headers=headers, data=payload)

    # Parse the JSON response
    data = json.loads(response.text)
    print(data)

    #Connect to the MySQL database
    cnx = mysql.connector.connect(
        user="user",
        password="1234",
        host="10.40.1.2",
        port=3306,
        database="criminal",
        auth_plugin="mysql_native_password"
    )

    # Construct the INSERT statement
    sql = """
    INSERT INTO summary (
        ip,
        inbound,
        outbound,
        country,
        country_code,
        isp,
        status
    ) VALUES (
        %(ip)s,
        %(inbound)s,
        %(outbound)s,
        %(country)s,
        %(country_code)s,
        %(isp)s,
        %(status)s
    )
    """

    # Define the data to be inserted
    insert_data = {
        "ip": data["ip"],
        "inbound": data["score"]["inbound"],
        "outbound": data["score"]["outbound"],
        "country": data["country"],
        "country_code": data["country_code"],
        "isp": data["isp"],
        "status": data["status"]
    }

    # Execute the INSERT statement
    cursor = cnx.cursor()
    cursor.execute(sql, insert_data)
    cnx.commit()


while True:
    with concurrent.futures.ThreadPoolExecutor() as executor:
        ip = generate_public_ip()
        print(ip)
        api(ip)
    pass