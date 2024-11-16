import datetime
import hashlib

access_key = "M27xtssPLv"
service_name = "timeservice"
timestamp = datetime.datetime.now().isoformat()

# STEP 1: Concatenate access key, service name and request timestamp

auth_string = access_key + service_name + timestamp
print(auth_string)

# STEP 2: Calculate the HMAC by using the SHA-1 hash algorithm. Make sure that the result actually is binary data 
# and not a hexadecimal representation of the resulting data. 

hash_object = hashlib.sha1(auth_string)
print(hash_object)


# STEP 3: Apply Base64 encoding to the resulting binary data: OlTRdhobJdUPDyM89lu0xKe4REY=.

# STEP 4: Construct the request. Remember to apply URL encoding to the parameter values in case your toolkit does
# not perform this operation automatically for you: 
# https://api.xmltime.com/timeservice?accesskey=NYczonwTxv&timestamp=2011-04-15T15%3A43%3A46Z&signature=OlTRdhobJdUPDyM89lu0xKe4REY%3D&further parameters… . 
