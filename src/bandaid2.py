from database import *
import datetime
import time

pricesql = PricesSQL()
users = UsersSQL()
projectfolder = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
latestprice={}
ret = {}
ct = datetime.datetime.now()

for crypto in users.get_coins_in_table():
    ret[crypto] = None

latestprice['prices'] = ret
latestprice['timestamp'] = int(round(ct.timestamp()))

for crypto in latestprice['prices']:

    #this try and except is to make sure that the api is working.
    #Various tries are made until the API actually sends the json
    scraped=False
    while scraped==False:
        try:
            response= requests.get(f'https://api.coingecko.com/api/v3/simple/price?ids={crypto}&vs_currencies=usd')
            response=response.json()
            response[crypto]
            response=dict(response)
            scraped=True
        except:
            time.sleep(1)
    
    latestprice['prices'][crypto]=round(response[crypto]['usd'],6)
    

with open(os.path.join(projectfolder,"data","latestprices.json"), "w") as f:
        latestprice=json.dump(latestprice,f,indent=0)           
