# Scraping Data from App Store

Revolut data


```python
# Step 1: Install the required package
!pip install app_store_scraper
```


```python
# Step 2: Import necessary libraries
import pandas as pd
import numpy as np
from app_store_scraper import AppStore
```


```python
pip install --upgrade requests urllib3 chardet
```

    Requirement already satisfied: requests in c:\users\nklom\anaconda\lib\site-packages (2.23.0)
    Collecting requests
      Obtaining dependency information for requests from https://files.pythonhosted.org/packages/f9/9b/335f9764261e915ed497fcdeb11df5dfd6f7bf257d4a6a2a686d80da4d54/requests-2.32.3-py3-none-any.whl.metadata
      Using cached requests-2.32.3-py3-none-any.whl.metadata (4.6 kB)
    Requirement already satisfied: urllib3 in c:\users\nklom\anaconda\lib\site-packages (1.25.11)
    Collecting urllib3
      Obtaining dependency information for urllib3 from https://files.pythonhosted.org/packages/c8/19/4ec628951a74043532ca2cf5d97b7b14863931476d117c471e8e2b1eb39f/urllib3-2.3.0-py3-none-any.whl.metadata
      Using cached urllib3-2.3.0-py3-none-any.whl.metadata (6.5 kB)
    Requirement already satisfied: chardet in c:\users\nklom\anaconda\lib\site-packages (3.0.4)
    Collecting chardet
      Obtaining dependency information for chardet from https://files.pythonhosted.org/packages/38/6f/f5fbc992a329ee4e0f288c1fe0e2ad9485ed064cac731ed2fe47dcc38cbf/chardet-5.2.0-py3-none-any.whl.metadata
      Using cached chardet-5.2.0-py3-none-any.whl.metadata (3.4 kB)
    Requirement already satisfied: charset-normalizer<4,>=2 in c:\users\nklom\anaconda\lib\site-packages (from requests) (2.0.4)
    Requirement already satisfied: idna<4,>=2.5 in c:\users\nklom\anaconda\lib\site-packages (from requests) (2.10)
    Requirement already satisfied: certifi>=2017.4.17 in c:\users\nklom\anaconda\lib\site-packages (from requests) (2023.11.17)
    Using cached requests-2.32.3-py3-none-any.whl (64 kB)
    Using cached urllib3-2.3.0-py3-none-any.whl (128 kB)
    Using cached chardet-5.2.0-py3-none-any.whl (199 kB)
    Installing collected packages: urllib3, chardet, requests
      Attempting uninstall: urllib3
        Found existing installation: urllib3 1.25.11
        Uninstalling urllib3-1.25.11:
          Successfully uninstalled urllib3-1.25.11
      Attempting uninstall: chardet
        Found existing installation: chardet 3.0.4
        Uninstalling chardet-3.0.4:
          Successfully uninstalled chardet-3.0.4
      Attempting uninstall: requests
        Found existing installation: requests 2.23.0
        Uninstalling requests-2.23.0:
          Successfully uninstalled requests-2.23.0
    Successfully installed chardet-5.2.0 requests-2.32.3 urllib3-2.3.0
    Note: you may need to restart the kernel to use updated packages.
    

    ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
    conda-repo-cli 1.0.75 requires requests_mock, which is not installed.
    app-store-scraper 0.3.5 requires requests==2.23.0, but you have requests 2.32.3 which is incompatible.
    botocore 1.29.76 requires urllib3<1.27,>=1.25.4, but you have urllib3 2.3.0 which is incompatible.
    conda-repo-cli 1.0.75 requires clyent==1.2.1, but you have clyent 1.2.2 which is incompatible.
    conda-repo-cli 1.0.75 requires PyYAML==6.0.1, but you have pyyaml 6.0 which is incompatible.
    conda-repo-cli 1.0.75 requires requests==2.31.0, but you have requests 2.32.3 which is incompatible.
    httpx 0.13.3 requires chardet==3.*, but you have chardet 5.2.0 which is incompatible.
    


```python
# Step 1: Install the required package (if not already installed)
!pip install app_store_scraper

# Step 2: Import necessary libraries
import pandas as pd
import numpy as np
import time
from app_store_scraper import AppStore
from IPython.display import display

```

    Requirement already satisfied: app_store_scraper in c:\users\nklom\anaconda\lib\site-packages (0.3.5)
    Requirement already satisfied: requests==2.23.0 in c:\users\nklom\anaconda\lib\site-packages (from app_store_scraper) (2.23.0)
    Requirement already satisfied: chardet<4,>=3.0.2 in c:\users\nklom\anaconda\lib\site-packages (from requests==2.23.0->app_store_scraper) (3.0.4)
    Requirement already satisfied: idna<3,>=2.5 in c:\users\nklom\anaconda\lib\site-packages (from requests==2.23.0->app_store_scraper) (2.10)
    Requirement already satisfied: urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1 in c:\users\nklom\anaconda\lib\site-packages (from requests==2.23.0->app_store_scraper) (1.25.11)
    Requirement already satisfied: certifi>=2017.4.17 in c:\users\nklom\anaconda\lib\site-packages (from requests==2.23.0->app_store_scraper) (2023.11.17)
    


```python
from app_store_scraper import AppStore
import pandas as pd
import numpy as np
import time
```


```python
# Configs
app_id = '932493382'
country = 'nl'
app_name = 'Revolut'
total_reviews_to_reach = 1000
batch_size = 1000
max_loops = 1  # Adjust this as needed
```


```python
# Collect all reviews (including duplicates)
all_reviews = []

for i in range(max_loops):
    print(f"Loop {i+1}: Re-initializing and fetching batch...")
    app = AppStore(country=country, app_name=app_name, app_id=app_id)
    app.review(how_many=batch_size)
    
    if not app.reviews:
        print("No reviews fetched — sleeping and retrying.")
        time.sleep(2)
        continue
    
    all_reviews.extend(app.reviews)
    
    print(f"Total collected (including duplicates): {len(all_reviews)}")
    time.sleep(2)  # Prevent rate-limiting
```

    Loop 1: Re-initializing and fetching batch...
    

    2025-03-28 10:48:26,393 [INFO] Base - Initialised: AppStore('nl', 'revolut', 932493382)
    2025-03-28 10:48:26,393 [INFO] Base - Ready to fetch reviews from: https://apps.apple.com/nl/app/revolut/id932493382
    2025-03-28 10:48:32,027 [INFO] Base - [id:932493382] Fetched 120 reviews (120 fetched in total)
    2025-03-28 10:48:39,109 [INFO] Base - [id:932493382] Fetched 240 reviews (240 fetched in total)
    2025-03-28 10:48:46,617 [INFO] Base - [id:932493382] Fetched 340 reviews (340 fetched in total)
    2025-03-28 10:48:54,175 [INFO] Base - [id:932493382] Fetched 460 reviews (460 fetched in total)
    2025-03-28 10:49:00,859 [INFO] Base - [id:932493382] Fetched 580 reviews (580 fetched in total)
    2025-03-28 10:49:07,019 [INFO] Base - [id:932493382] Fetched 680 reviews (680 fetched in total)
    2025-03-28 10:49:13,229 [INFO] Base - [id:932493382] Fetched 780 reviews (780 fetched in total)
    2025-03-28 10:49:20,102 [INFO] Base - [id:932493382] Fetched 900 reviews (900 fetched in total)
    2025-03-28 10:49:25,624 [INFO] Base - [id:932493382] Fetched 1000 reviews (1000 fetched in total)
    

    Total collected (including duplicates): 1000
    


```python
# Convert to DataFrame (including duplicates)
df_raw = pd.DataFrame(np.array(all_reviews), columns=['review'])
df_full = df_raw.join(pd.DataFrame(df_raw.pop('review').tolist()))
```


```python
# Remove duplicates 
df_full = df_full.drop_duplicates(subset=['date', 'userName', 'title', 'review'])
```


```python
# Identify duplicated rows (both first and subsequent duplicates)
duplicates = df_full.duplicated(subset=['date', 'userName', 'title', 'review'], keep=False)

# Keep only non-duplicated rows
df_full = df_full[~duplicates]
```


```python
display(df_full)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>review</th>
      <th>rating</th>
      <th>isEdited</th>
      <th>title</th>
      <th>userName</th>
      <th>developerResponse</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2019-09-24 06:35:05</td>
      <td>Ik heb mijn eerste betalingen gedaan en ben ze...</td>
      <td>5</td>
      <td>False</td>
      <td>Prima app</td>
      <td>jatr63</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2017-12-07 19:39:46</td>
      <td>“Crypto now available in app”\n* opens app *\n...</td>
      <td>5</td>
      <td>False</td>
      <td>Update useful for premium users only</td>
      <td>rainygarden</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2020-03-18 19:09:54</td>
      <td>Because of the tons of positive reviews you mi...</td>
      <td>1</td>
      <td>False</td>
      <td>Read the negative reviews, not the positive!!!</td>
      <td>kees de wrap koning</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2020-02-16 21:35:02</td>
      <td>One day your account will be locked without re...</td>
      <td>1</td>
      <td>False</td>
      <td>Revolut will run away with your money</td>
      <td>AlexMBone</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2021-04-20 17:50:23</td>
      <td>Really dislike the latest update. Please just ...</td>
      <td>5</td>
      <td>False</td>
      <td>Consistency please</td>
      <td>JordGG93</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>995</th>
      <td>2020-02-11 21:00:56</td>
      <td>Na update van vandaag.  Kan ik niet neer inlog...</td>
      <td>1</td>
      <td>False</td>
      <td>Jammer</td>
      <td>user20120</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>996</th>
      <td>2020-02-08 17:59:13</td>
      <td>Account locked 2 month ago. Any information wh...</td>
      <td>1</td>
      <td>False</td>
      <td>Account locked / Questions ate ignored</td>
      <td>vlad.82.82.82</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>997</th>
      <td>2020-02-07 14:13:59</td>
      <td>Fix this, there are no other ways to add money...</td>
      <td>2</td>
      <td>False</td>
      <td>Set up Apple Pay is not working</td>
      <td>Unnamed Resource</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>998</th>
      <td>2020-01-29 12:35:37</td>
      <td>The app has a better lay-out than N26 to be ho...</td>
      <td>5</td>
      <td>False</td>
      <td>Easy in use and good customer service</td>
      <td>joelielie</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>999</th>
      <td>2020-01-30 19:09:01</td>
      <td>I have my account blocked for 3 weeks and on l...</td>
      <td>1</td>
      <td>False</td>
      <td>Customer service</td>
      <td>P0p@L!e</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>1000 rows × 7 columns</p>
</div>



```python
df_full.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Revolut_AppStore_reviews.xlsx", index=False)
```

Bunq data


```python
# Configs
app_id = '1021178150'
country = 'nl'
app_name = 'Bunq'
total_reviews_to_reach = 1000
batch_size = 1000
max_loops = 1  # Adjust this as needed
```


```python
# Collect all reviews (including duplicates) for Bunq
all_reviews_B = []

for i in range(max_loops):
    print(f"Loop {i+1}: Re-initializing and fetching batch...")
    app = AppStore(country=country, app_name=app_name, app_id=app_id)
    app.review(how_many=batch_size)
    
    if not app.reviews:
        print("No reviews fetched — sleeping and retrying.")
        time.sleep(2)
        continue
    
    all_reviews_B.extend(app.reviews)  # <- this is now correct
    
    print(f"Total collected (including duplicates): {len(all_reviews_B)}")
    time.sleep(2)  # Prevent rate-limiting

```

    Loop 1: Re-initializing and fetching batch...
    

    2025-03-28 09:54:12,136 [INFO] Base - Initialised: AppStore('nl', 'bunq', 1021178150)
    2025-03-28 09:54:12,136 [INFO] Base - Ready to fetch reviews from: https://apps.apple.com/nl/app/bunq/id1021178150
    2025-03-28 09:54:17,854 [INFO] Base - [id:1021178150] Fetched 100 reviews (100 fetched in total)
    2025-03-28 09:54:23,998 [INFO] Base - [id:1021178150] Fetched 220 reviews (220 fetched in total)
    2025-03-28 09:54:30,442 [INFO] Base - [id:1021178150] Fetched 340 reviews (340 fetched in total)
    2025-03-28 09:54:36,594 [INFO] Base - [id:1021178150] Fetched 460 reviews (460 fetched in total)
    2025-03-28 09:54:43,245 [INFO] Base - [id:1021178150] Fetched 580 reviews (580 fetched in total)
    2025-03-28 09:54:49,588 [INFO] Base - [id:1021178150] Fetched 700 reviews (700 fetched in total)
    2025-03-28 09:54:56,262 [INFO] Base - [id:1021178150] Fetched 820 reviews (820 fetched in total)
    2025-03-28 09:55:03,003 [INFO] Base - [id:1021178150] Fetched 940 reviews (940 fetched in total)
    2025-03-28 09:55:06,187 [INFO] Base - [id:1021178150] Fetched 1000 reviews (1000 fetched in total)
    

    Total collected (including duplicates): 1000
    


```python
# Convert to DataFrame (including duplicates)
df_raw_B = pd.DataFrame(np.array(all_reviews_B), columns=['review'])
df_full_B = df_raw_B.join(pd.DataFrame(df_raw_B.pop('review').tolist()))
```


```python
# Remove duplicates 
df_full_B = df_full_B.drop_duplicates(subset=['date', 'userName', 'title', 'review'])
```


```python
display(df_full_B)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>developerResponse</th>
      <th>review</th>
      <th>rating</th>
      <th>isEdited</th>
      <th>userName</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2018-03-18 21:55:14</td>
      <td>{'id': 2954332, 'body': '🙂 Thank you for your ...</td>
      <td>De enige reden dat bunq investeert, in staatso...</td>
      <td>5</td>
      <td>False</td>
      <td>whaha</td>
      <td>Meest ethische bank</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2020-06-18 14:36:10</td>
      <td>{'id': 22787663, 'body': 'Sorry to see that yo...</td>
      <td>Dit is de eerste keer in mijn leven dat ik mij...</td>
      <td>1</td>
      <td>False</td>
      <td>Robert U NL</td>
      <td>Wat een waardeloze update</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2020-06-18 15:07:05</td>
      <td>{'id': 22787610, 'body': 'Sorry to see that yo...</td>
      <td>With the V3 update Bunq totally messed up! Clu...</td>
      <td>1</td>
      <td>False</td>
      <td>R@lfee</td>
      <td>V3 totally messed up</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2020-06-18 14:12:30</td>
      <td>{'id': 22788124, 'body': 'Sorry to see that yo...</td>
      <td>Grote fan geweest van Bunq. Maar met de laatst...</td>
      <td>1</td>
      <td>False</td>
      <td>slammer1024</td>
      <td>Verschrikkelijk na update</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2020-06-18 14:53:47</td>
      <td>{'id': 22787642, 'body': 'Sorry to see that yo...</td>
      <td>Ik ben niet blij met de uitstraling en ik moet...</td>
      <td>1</td>
      <td>False</td>
      <td>golden oozaru</td>
      <td>Update V3</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>995</th>
      <td>2024-03-15 14:44:45</td>
      <td>{'id': 42636766, 'body': 'Hey there! Thank you...</td>
      <td>Deze mensen zijn op niks ik doe dagelijkse ver...</td>
      <td>1</td>
      <td>False</td>
      <td>identificatie</td>
      <td>slecht</td>
    </tr>
    <tr>
      <th>996</th>
      <td>2024-03-15 13:54:09</td>
      <td>{'id': 42636735, 'body': 'Hi there! Thank you ...</td>
      <td>I used this app for five years. It has been a ...</td>
      <td>1</td>
      <td>False</td>
      <td>Zoarr990</td>
      <td>Bye bye Bunq after 5 years</td>
    </tr>
    <tr>
      <th>997</th>
      <td>2024-03-14 09:03:18</td>
      <td>{'id': 42622621, 'body': 'Hey there! Thank you...</td>
      <td>I started using bunq some time ago and I recom...</td>
      <td>5</td>
      <td>False</td>
      <td>Peloso xotinguiba</td>
      <td>Great bank!</td>
    </tr>
    <tr>
      <th>998</th>
      <td>2024-03-11 13:13:38</td>
      <td>{'id': 42555089, 'body': 'Hi there Tijmen! Tha...</td>
      <td>Every other month they release a new version f...</td>
      <td>1</td>
      <td>False</td>
      <td>Tijmen van Kempen</td>
      <td>Stop “improving”</td>
    </tr>
    <tr>
      <th>999</th>
      <td>2024-03-09 14:15:33</td>
      <td>{'id': 42505116, 'body': 'Hi there! Thanks for...</td>
      <td>After the last update budgeting does not work....</td>
      <td>1</td>
      <td>False</td>
      <td>Ksjuksu</td>
      <td>Budgeting doesn’t work</td>
    </tr>
  </tbody>
</table>
<p>1000 rows × 7 columns</p>
</div>



```python
df_full_B.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Bunq_AppStore_reviews.xlsx", index=False)
```

Mollie


```python
# Configs
app_id = '1473455257'
country = 'nl'
app_name = 'Mollie'
total_reviews_to_reach = 1000
batch_size = 1000
max_loops = 1  # Adjust this as needed
```


```python
# Collect all reviews (including duplicates)
all_reviews_M = []

for i in range(max_loops):
    print(f"Loop {i+1}: Re-initializing and fetching batch...")
    app = AppStore(country=country, app_name=app_name, app_id=app_id)
    app.review(how_many=batch_size)
    
    if not app.reviews:
        print("No reviews fetched — sleeping and retrying.")
        time.sleep(2)
        continue
    
    all_reviews_M.extend(app.reviews)
    
    print(f"Total collected (including duplicates): {len(all_reviews_M)}")
    time.sleep(2)  # Prevent rate-limiting
```

    Loop 1: Re-initializing and fetching batch...
    

    2025-03-28 09:55:37,380 [INFO] Base - Initialised: AppStore('nl', 'mollie', 1473455257)
    2025-03-28 09:55:37,380 [INFO] Base - Ready to fetch reviews from: https://apps.apple.com/nl/app/mollie/id1473455257
    2025-03-28 09:55:43,043 [INFO] Base - [id:1473455257] Fetched 80 reviews (80 fetched in total)
    2025-03-28 09:55:44,066 [INFO] Base - [id:1473455257] Fetched 93 reviews (93 fetched in total)
    

    Total collected (including duplicates): 93
    


```python
# Convert to DataFrame (including duplicates)
df_raw_M = pd.DataFrame(np.array(all_reviews_M), columns=['review'])
df_full_M = df_raw_M.join(pd.DataFrame(df_raw_M.pop('review').tolist()))
```


```python
display(df_full_M)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>review</th>
      <th>rating</th>
      <th>isEdited</th>
      <th>title</th>
      <th>userName</th>
      <th>developerResponse</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2025-03-08 02:33:45</td>
      <td>Gamechanger</td>
      <td>5</td>
      <td>False</td>
      <td>Top</td>
      <td>Dintje kabintje</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2019-12-18 17:06:00</td>
      <td>Een mooie app zeg! Leuk dat je je Mollie stati...</td>
      <td>4</td>
      <td>False</td>
      <td>Mooie start!</td>
      <td>AnoniemNL</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2025-01-21 23:12:42</td>
      <td>Helemaal prima, alleen jammer dat je niet bij ...</td>
      <td>5</td>
      <td>False</td>
      <td>Werkt prima</td>
      <td>Whoehoeee1353</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2025-03-05 15:53:37</td>
      <td>Het eerste tabblad bevat slechts promoties van...</td>
      <td>2</td>
      <td>False</td>
      <td>Niet handig</td>
      <td>MeneerDeVries</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2025-01-12 12:48:00</td>
      <td>Werkt erg goed, simpel in gebruik en betrouwbaar.</td>
      <td>5</td>
      <td>False</td>
      <td>Zeer tevreden</td>
      <td>Coaching by Lux</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>88</th>
      <td>2019-12-18 19:17:30</td>
      <td>Top dat er een mollie app is alleen jammer dat...</td>
      <td>3</td>
      <td>False</td>
      <td>Mooi design weinig functies</td>
      <td>VHuub</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>89</th>
      <td>2019-12-18 13:11:56</td>
      <td>Ik gebruik al jaren Mollie. Ze ontwikkelen alt...</td>
      <td>5</td>
      <td>False</td>
      <td>Mollie is een geweldige betaalprovider</td>
      <td>Cygnus99</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>90</th>
      <td>2019-12-18 14:20:03</td>
      <td>Mooi dat Mollie een app ontwikkelt met betalin...</td>
      <td>3</td>
      <td>False</td>
      <td>Overzicht zonder functionaliteiten</td>
      <td>DChiel</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>91</th>
      <td>2019-12-18 14:05:22</td>
      <td>Top dat er eindelijk een app is! Met een taal ...</td>
      <td>4</td>
      <td>False</td>
      <td>Top! Nu nog een Nederlandse versie</td>
      <td>Dot Circle</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>92</th>
      <td>2019-12-18 12:27:51</td>
      <td>App is fast &amp; beautiful. Great stuff. With thi...</td>
      <td>5</td>
      <td>False</td>
      <td>Pure awesomeness</td>
      <td>Rygu Woo</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>93 rows × 7 columns</p>
</div>



```python
df_full_M.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Mollie_AppStore_reviews.xlsx", index=False)
```

N26


```python
# Configs
app_id = '956857223'
country = 'nl'
app_name = 'N26'
total_reviews_to_reach = 2000
batch_size = 1000
max_loops = 1  # Adjust this as needed
```


```python
# Collect all reviews (including duplicates)
all_reviews_N = []

for i in range(max_loops):
    print(f"Loop {i+1}: Re-initializing and fetching batch...")
    app = AppStore(country=country, app_name=app_name, app_id=app_id)
    app.review(how_many=batch_size)
    
    if not app.reviews:
        print("No reviews fetched — sleeping and retrying.")
        time.sleep(2)
        continue
    
    all_reviews_N.extend(app.reviews)
    
    print(f"Total collected (including duplicates): {len(all_reviews_N)}")
    time.sleep(2)  # Prevent rate-limiting
```

    Loop 1: Re-initializing and fetching batch...
    

    2025-03-28 09:58:58,921 [INFO] Base - Initialised: AppStore('nl', 'n26', 956857223)
    2025-03-28 09:58:58,926 [INFO] Base - Ready to fetch reviews from: https://apps.apple.com/nl/app/n26/id956857223
    2025-03-28 09:59:04,630 [INFO] Base - [id:956857223] Fetched 100 reviews (100 fetched in total)
    2025-03-28 09:59:11,441 [INFO] Base - [id:956857223] Fetched 220 reviews (220 fetched in total)
    2025-03-28 09:59:18,300 [INFO] Base - [id:956857223] Fetched 340 reviews (340 fetched in total)
    2025-03-28 09:59:24,739 [INFO] Base - [id:956857223] Fetched 460 reviews (460 fetched in total)
    2025-03-28 09:59:25,776 [INFO] Base - [id:956857223] Fetched 462 reviews (462 fetched in total)
    

    Total collected (including duplicates): 462
    


```python
# Convert to DataFrame (including duplicates)
df_raw_N = pd.DataFrame(np.array(all_reviews_N), columns=['review'])
df_full_N = df_raw_N.join(pd.DataFrame(df_raw_N.pop('review').tolist()))
```


```python
display(df_full_N)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>review</th>
      <th>rating</th>
      <th>isEdited</th>
      <th>title</th>
      <th>userName</th>
      <th>developerResponse</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2020-04-15 13:31:45</td>
      <td>valeriol7860 de code om 15 euro op de kaart te...</td>
      <td>5</td>
      <td>False</td>
      <td>Best Bank</td>
      <td>olan.acc</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2019-06-14 20:13:34</td>
      <td>First bank that doesn’t charge you for any costs!</td>
      <td>5</td>
      <td>False</td>
      <td>Easy</td>
      <td>Chrisis8</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2020-09-11 14:06:24</td>
      <td>Eigenlijk wilde ik N26 gebruiken als vaste las...</td>
      <td>3</td>
      <td>False</td>
      <td>Tot nu toe prima</td>
      <td>Virgie1234</td>
      <td>{'id': 21541639, 'body': 'Hey, thank you for y...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2018-02-19 19:45:25</td>
      <td>Of you guys want to take off here in The Nethe...</td>
      <td>4</td>
      <td>False</td>
      <td>Looks promising</td>
      <td>meeljeme</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2018-05-15 18:01:27</td>
      <td>Help me! I want to verify my account but when ...</td>
      <td>1</td>
      <td>False</td>
      <td>App Issue</td>
      <td>Rumbl3Shot</td>
      <td>{'id': 3541420, 'body': 'Hey! We're sorry abou...</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>457</th>
      <td>2016-01-27 11:00:23</td>
      <td>I get a notification  that I've paid even befo...</td>
      <td>5</td>
      <td>False</td>
      <td>So convenient</td>
      <td>mirresnelting</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>458</th>
      <td>2016-01-10 15:49:33</td>
      <td>Ver nice App its modern ad works perfectly. U ...</td>
      <td>5</td>
      <td>False</td>
      <td>Great App</td>
      <td>Hanif.kbh</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>459</th>
      <td>2015-10-28 17:28:31</td>
      <td>Since I got Number26, the whole German banking...</td>
      <td>5</td>
      <td>False</td>
      <td>Best banking app</td>
      <td>nzlatev</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>460</th>
      <td>2017-01-16 01:35:17</td>
      <td>en nu naar mars!</td>
      <td>5</td>
      <td>False</td>
      <td>vruchtbaar</td>
      <td>09081981</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>461</th>
      <td>2025-03-26 17:12:03</td>
      <td>2 sterren omdat N26 gratis is, maar de onderst...</td>
      <td>2</td>
      <td>False</td>
      <td>Teleurstellende service</td>
      <td>c0192847</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>462 rows × 7 columns</p>
</div>



```python
df_full_N.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\N26_AppStore_reviews.xlsx", index=False)
```

# Google play

Bunq


```python
pip install google-play-scraper

```

    Requirement already satisfied: google-play-scraper in c:\users\nklom\anaconda\lib\site-packages (1.2.7)
    Note: you may need to restart the kernel to use updated packages.
    


```python
from google_play_scraper import Sort, reviews
import pandas as pd
import time


```


```python
app_id_N = 'com.bunq.android'
total_reviews_to_fetch = 5000

all_reviews_GP_B_NL = []
next_token = None
prev_count = 0

while len(all_reviews_GP_B_NL) < total_reviews_to_fetch:
    print(f"Collected {len(all_reviews_GP_B_NL)} reviews...")

    result, next_token = reviews(
        app_id_N,
        lang='nl',
        country='nl',
        sort=Sort.NEWEST,
        count=200,
        continuation_token=next_token
    )

    if not result:
        print("⚠️ No more reviews returned. Stopping.")
        break

    all_reviews_GP_B_NL.extend(result)

    if len(all_reviews_GP_B_NL) == prev_count:
        print("⚠️ Review count not increasing. Stopping.")
        break

    prev_count = len(all_reviews_GP_B_NL)

    if not next_token:
        print("✅ No continuation token. All available reviews fetched.")
        break

```

    Collected 0 reviews...
    Collected 200 reviews...
    Collected 400 reviews...
    Collected 600 reviews...
    Collected 800 reviews...
    Collected 1000 reviews...
    Collected 1200 reviews...
    Collected 1400 reviews...
    Collected 1600 reviews...
    Collected 1800 reviews...
    Collected 2000 reviews...
    Collected 2200 reviews...
    Collected 2400 reviews...
    Collected 2524 reviews...
    ⚠️ No more reviews returned. Stopping.
    


```python
# Remove duplicates
df_GP_B_NL = pd.DataFrame(all_reviews_GP_B_NL)
```


```python
display(df_GP_B_NL)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>reviewId</th>
      <th>userName</th>
      <th>userImage</th>
      <th>content</th>
      <th>score</th>
      <th>thumbsUpCount</th>
      <th>reviewCreatedVersion</th>
      <th>at</th>
      <th>replyContent</th>
      <th>repliedAt</th>
      <th>appVersion</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>152b2c16-6f77-4152-9269-09eba35e5cd9</td>
      <td>Ineke Don</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>Ik gebruik de app zakelijk. Eenvoudig in gebru...</td>
      <td>5</td>
      <td>0</td>
      <td>27.12.3</td>
      <td>2025-04-20 10:13:43</td>
      <td>Hey Ineke! Thank you for the five-star review 🌟</td>
      <td>2025-04-21 08:58:39</td>
      <td>27.12.3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>008190f0-0b74-478b-9d3e-05b137395d2f</td>
      <td>purp frogs</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>snel op te zetten en goed als spaarrekening. e...</td>
      <td>4</td>
      <td>2</td>
      <td>27.12.3</td>
      <td>2025-04-16 15:57:51</td>
      <td>Hey! Thanks for the positive review! We’d love...</td>
      <td>2025-04-16 20:27:46</td>
      <td>27.12.3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1892fab5-f935-409d-a1e1-e9834284b723</td>
      <td>Hendrika Ploeg van der</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Fijne app,en betrouwbaar</td>
      <td>5</td>
      <td>3</td>
      <td>27.12.3</td>
      <td>2025-04-16 12:54:46</td>
      <td>Hey Hendrika! Thank you for the five-star revi...</td>
      <td>2025-04-16 15:44:43</td>
      <td>27.12.3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>570f41cf-9583-4599-b483-688d884ba2f5</td>
      <td>E Rooks</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>snel een extra spaarrekening geopend. dat ging...</td>
      <td>5</td>
      <td>3</td>
      <td>27.12.3</td>
      <td>2025-04-16 10:40:20</td>
      <td>Hey! Thank you for the five-star review 🌟</td>
      <td>2025-04-16 16:26:33</td>
      <td>27.12.3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>91ed07cb-9b01-4959-ab16-374a6183251d</td>
      <td>M T</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>Erg vervelend! En vooral omdat ik wel de perso...</td>
      <td>1</td>
      <td>0</td>
      <td>None</td>
      <td>2025-04-15 08:16:21</td>
      <td>Hey there 👋 Providing top-notch support to our...</td>
      <td>2025-04-16 20:31:53</td>
      <td>None</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2519</th>
      <td>2a3dacd3-866c-4c8a-b1f7-58098d1b965f</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Registratie via website zou veel makkelijker z...</td>
      <td>2</td>
      <td>2</td>
      <td>None</td>
      <td>2015-11-25 13:12:54</td>
      <td>None</td>
      <td>NaT</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2520</th>
      <td>78f2884d-3878-4529-8312-2ffcf95675fc</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Foto's van je id maken  Dat is jammer. Niet ec...</td>
      <td>2</td>
      <td>5</td>
      <td>1.0.15</td>
      <td>2015-11-25 13:09:27</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0.15</td>
    </tr>
    <tr>
      <th>2521</th>
      <td>14f3b091-dcba-4e18-9b29-4e8bcefaa643</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>super handige app, lekker overzichtelijk ook</td>
      <td>4</td>
      <td>2</td>
      <td>None</td>
      <td>2015-11-25 12:55:37</td>
      <td>None</td>
      <td>NaT</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2522</th>
      <td>64df97bc-8545-4271-96e0-af73f186b1f5</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Mooie start bunqers! Registratie was appeltje-...</td>
      <td>4</td>
      <td>3</td>
      <td>1.0.15</td>
      <td>2015-11-25 12:16:11</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0.15</td>
    </tr>
    <tr>
      <th>2523</th>
      <td>2140c6e5-4fca-462e-9872-65ffb490e2f8</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Eindelijk een app waarmee je ècht meer kan dan...</td>
      <td>5</td>
      <td>2</td>
      <td>1.0.15</td>
      <td>2015-11-25 09:52:52</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0.15</td>
    </tr>
  </tbody>
</table>
<p>2524 rows × 11 columns</p>
</div>



```python
df_GP_B_NL.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Bunq_GooglePlay_reviews.xlsx", index=False)
```

Mollie


```python
app_id = 'com.mollie.android'
total_reviews_to_fetch = 5000

all_reviews_mollie = []
next_token = None
prev_count = 0

while len(all_reviews_mollie) < total_reviews_to_fetch:
    print(f"Collected {len(all_reviews_mollie)} reviews...")

    result, next_token = reviews(
        app_id,
        lang='nl',
        country='nl',  # Netherlands
        sort=Sort.NEWEST,
        count=100,
        continuation_token=next_token
    )

    if not result:
        print("⚠️ No more reviews returned. Stopping.")
        break

    all_reviews_mollie.extend(result)

    if len(all_reviews_mollie) == prev_count:
        print("⚠️ Review count not increasing. Stopping.")
        break

    prev_count = len(all_reviews_mollie)

    if not next_token:
        print("✅ No continuation token. All available reviews fetched.")
        break
```

    Collected 0 reviews...
    Collected 100 reviews...
    Collected 180 reviews...
    ⚠️ No more reviews returned. Stopping.
    


```python
# Convert to DataFrame
df_mollie_nl = pd.DataFrame(all_reviews_mollie)
```


```python
display(df_mollie_nl)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>reviewId</th>
      <th>userName</th>
      <th>userImage</th>
      <th>content</th>
      <th>score</th>
      <th>thumbsUpCount</th>
      <th>reviewCreatedVersion</th>
      <th>at</th>
      <th>replyContent</th>
      <th>repliedAt</th>
      <th>appVersion</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>d49a9256-ee14-482c-99e4-b0684ec842bb</td>
      <td>moon Visser</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Helemaal blij 😉💕🍀</td>
      <td>5</td>
      <td>0</td>
      <td>2.24.13</td>
      <td>2025-02-17 17:29:58</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.24.13</td>
    </tr>
    <tr>
      <th>1</th>
      <td>a0e047af-0559-4e74-b906-27669fed8e27</td>
      <td>Roland Taams</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Super system!. Alleen Tap to Pay werkt nog nie...</td>
      <td>5</td>
      <td>0</td>
      <td>2.24.13</td>
      <td>2025-02-10 14:45:26</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.24.13</td>
    </tr>
    <tr>
      <th>2</th>
      <td>d739b079-0f8c-4f25-b1b8-b35e76a7a8f3</td>
      <td>P rimus</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>krijg geen mails van betalingen!</td>
      <td>1</td>
      <td>0</td>
      <td>2.24.13</td>
      <td>2025-02-08 09:44:30</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.24.13</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cd56a249-3b19-4763-97c0-746d4f3070c5</td>
      <td>Kevin Mulkers (Deejay Dm)</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Werkt super werk er nu al 3 jaar mee dit verma...</td>
      <td>5</td>
      <td>0</td>
      <td>2.24.13</td>
      <td>2025-02-05 17:17:16</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.24.13</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5d8dada4-1661-4670-b5c5-f51f7b2a0d54</td>
      <td>Madeleine K</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>Fijn systeem, maar 3 dubbel verificatie bij in...</td>
      <td>3</td>
      <td>0</td>
      <td>2.19.108</td>
      <td>2024-11-16 13:03:07</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.19.108</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>175</th>
      <td>4e92a1ef-d9c6-427c-942f-8541fed9fdc5</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Leuke aanvulling, maar ik zou de grafiek ander...</td>
      <td>4</td>
      <td>1</td>
      <td>1.13.3</td>
      <td>2020-02-26 12:39:15</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.13.3</td>
    </tr>
    <tr>
      <th>176</th>
      <td>ff47ac26-a5a7-47e8-8201-8b1edba6d9cc</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Onbruikbaar omdat ik niet kan inloggen.</td>
      <td>1</td>
      <td>0</td>
      <td>1.13.3</td>
      <td>2020-02-21 17:43:49</td>
      <td>We're sorry to hear that! Can you send your or...</td>
      <td>2020-06-08 18:19:21</td>
      <td>1.13.3</td>
    </tr>
    <tr>
      <th>177</th>
      <td>cf6b51c6-d6e6-4385-8aea-f82fc84fb0ee</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Heel blij mee! Eindelijk snel mobiel in de gat...</td>
      <td>4</td>
      <td>0</td>
      <td>1.13.3</td>
      <td>2020-02-20 20:57:52</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.13.3</td>
    </tr>
    <tr>
      <th>178</th>
      <td>0c1151b9-b1d3-466a-b902-4502d3748db1</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Handig dat het er eindelijk voor Android is en...</td>
      <td>4</td>
      <td>0</td>
      <td>1.13.1</td>
      <td>2020-02-18 15:38:56</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.13.1</td>
    </tr>
    <tr>
      <th>179</th>
      <td>69de506f-639b-43d7-9ad7-0bb14064cfd1</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Perfect! Goeie app!</td>
      <td>5</td>
      <td>0</td>
      <td>1.13.1</td>
      <td>2020-02-18 14:32:09</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.13.1</td>
    </tr>
  </tbody>
</table>
<p>180 rows × 11 columns</p>
</div>



```python
df_mollie_nl.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Mollie_GooglePlay_reviews.xlsx", index=False)
```

Revolut


```python
# Correct Revolut app ID
app_id = 'com.revolut.revolut'
total_reviews_to_fetch = 5000

all_reviews_revolut_nl = []
next_token = None
prev_count = 0

while len(all_reviews_revolut_nl) < total_reviews_to_fetch:
    print(f"Collected {len(all_reviews_revolut_nl)} reviews...")

    result, next_token = reviews(
        app_id,
        lang='nl',        # Dutch language
        country='nl',     # Netherlands
        sort=Sort.NEWEST,
        count=200,
        continuation_token=next_token
    )

    if not result:
        print("⚠️ No more reviews returned. Stopping.")
        break

    all_reviews_revolut_nl.extend(result)

    if len(all_reviews_revolut_nl) == prev_count:
        print("⚠️ Review count not increasing. Stopping.")
        break

    prev_count = len(all_reviews_revolut_nl)

    if not next_token:
        print("✅ No continuation token. All available reviews fetched.")
        break
```

    Collected 0 reviews...
    Collected 200 reviews...
    Collected 400 reviews...
    Collected 600 reviews...
    Collected 800 reviews...
    Collected 1000 reviews...
    Collected 1200 reviews...
    Collected 1400 reviews...
    Collected 1600 reviews...
    Collected 1800 reviews...
    Collected 2000 reviews...
    Collected 2200 reviews...
    Collected 2400 reviews...
    Collected 2600 reviews...
    Collected 2800 reviews...
    Collected 3000 reviews...
    Collected 3200 reviews...
    Collected 3400 reviews...
    Collected 3600 reviews...
    Collected 3800 reviews...
    Collected 4000 reviews...
    Collected 4200 reviews...
    Collected 4400 reviews...
    Collected 4600 reviews...
    Collected 4800 reviews...
    Collected 4848 reviews...
    ⚠️ No more reviews returned. Stopping.
    


```python
# Convert to DataFrame and save
df_revolut_nl = pd.DataFrame(all_reviews_revolut_nl)
```


```python
display(df_revolut_nl)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>reviewId</th>
      <th>userName</th>
      <th>userImage</th>
      <th>content</th>
      <th>score</th>
      <th>thumbsUpCount</th>
      <th>reviewCreatedVersion</th>
      <th>at</th>
      <th>replyContent</th>
      <th>repliedAt</th>
      <th>appVersion</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16169745-2b88-45e1-85ee-e01803fa7cec</td>
      <td>Angela Vermeer</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>zeer fijne bank</td>
      <td>5</td>
      <td>0</td>
      <td>10.68</td>
      <td>2025-03-26 12:06:07</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.68</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7a2b7b40-c189-4036-939c-c6b98a8fdb8b</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>overzichtelijk en werkt snel. app is soms niet...</td>
      <td>4</td>
      <td>0</td>
      <td>10.70.1</td>
      <td>2025-03-26 11:17:52</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.70.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>d9556524-6d5d-4f25-b67f-da55e1153661</td>
      <td>Kai</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>als er meer geld 💸 op stond vond ik het een be...</td>
      <td>4</td>
      <td>0</td>
      <td>10.68</td>
      <td>2025-03-26 08:22:21</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.68</td>
    </tr>
    <tr>
      <th>3</th>
      <td>83cd0999-f039-4a82-8283-07335753037a</td>
      <td>Klaas Veijer</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>wat een ramp is deze bank zeg. Bijna elke tran...</td>
      <td>1</td>
      <td>0</td>
      <td>10.70</td>
      <td>2025-03-26 00:05:21</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.70</td>
    </tr>
    <tr>
      <th>4</th>
      <td>08d44ea4-3cdb-48db-b337-fe5a48931945</td>
      <td>Paul Hurkmans</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>Makkelijk en overzichtelijk</td>
      <td>5</td>
      <td>0</td>
      <td>10.70</td>
      <td>2025-03-25 23:14:13</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.70</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>4843</th>
      <td>306f2e68-4767-424d-8780-229160886b0f</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Superb card tool. Really no costs.</td>
      <td>5</td>
      <td>2</td>
      <td>2.5.7</td>
      <td>2016-07-11 11:55:49</td>
      <td>We're so glad you are enjoying Revolut! \n\nTh...</td>
      <td>2016-07-11 19:35:27</td>
      <td>2.5.7</td>
    </tr>
    <tr>
      <th>4844</th>
      <td>8a8bc733-1d0e-48d6-b7a9-6a1a09f107c0</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Top up from Belgium slow because we must use b...</td>
      <td>4</td>
      <td>4</td>
      <td>2.5</td>
      <td>2016-05-29 20:52:45</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.5</td>
    </tr>
    <tr>
      <th>4845</th>
      <td>3946d7af-2d3d-4e46-bf74-5263b1af0aec</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Will Revolut ever get a real IBAN bank account...</td>
      <td>4</td>
      <td>3</td>
      <td>2.0.6</td>
      <td>2016-01-26 17:17:37</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.0.6</td>
    </tr>
    <tr>
      <th>4846</th>
      <td>66f837f5-2307-4bcc-b51a-8dba08a8f174</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Some more ways to top up would be nice. E.g. h...</td>
      <td>4</td>
      <td>5</td>
      <td>1.3.9</td>
      <td>2015-08-23 14:42:08</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.3.9</td>
    </tr>
    <tr>
      <th>4847</th>
      <td>12df58ce-f58d-486c-8225-b91b172cfc0b</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Het is nog niet 100% maar vooralsnog ben ik ze...</td>
      <td>4</td>
      <td>3</td>
      <td>1.3.9</td>
      <td>2015-08-22 18:38:25</td>
      <td>Hi Frans,\n\nAny issues you have we would be h...</td>
      <td>2015-08-23 17:06:16</td>
      <td>1.3.9</td>
    </tr>
  </tbody>
</table>
<p>4848 rows × 11 columns</p>
</div>



```python
df_revolut_nl.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Revolut_nl_GooglePlay_reviews.xlsx", index=False)
```


```python
# Revolut app ID (same as before)
app_id_en = 'com.revolut.revolut'
total_reviews_to_fetch_en = 90000

all_reviews_revolut_en = []
next_token_en = None
prev_count_en = 0

while len(all_reviews_revolut_en) < total_reviews_to_fetch_en:
    print(f"Collected {len(all_reviews_revolut_en)} reviews...")

    result_en, next_token_en = reviews(
        app_id_en,
        lang='en',        # English language
        country='nl',     # Still from Netherlands
        sort=Sort.NEWEST,
        count=200,
        continuation_token=next_token_en
    )

    if not result_en:
        print("⚠️ No more reviews returned. Stopping.")
        break

    all_reviews_revolut_en.extend(result_en)

    if len(all_reviews_revolut_en) == prev_count_en:
        print("⚠️ Review count not increasing. Stopping.")
        break

    prev_count_en = len(all_reviews_revolut_en)

    if not next_token_en:
        print("✅ No continuation token. All available reviews fetched.")
        break

```

    Collected 0 reviews...
    Collected 200 reviews...
    Collected 400 reviews...
    Collected 600 reviews...
    Collected 800 reviews...
    Collected 1000 reviews...
    Collected 1200 reviews...
    Collected 1400 reviews...
    Collected 1600 reviews...
    Collected 1800 reviews...
    Collected 2000 reviews...
    Collected 2200 reviews...
    Collected 2400 reviews...
    Collected 2600 reviews...
    Collected 2800 reviews...
    Collected 3000 reviews...
    Collected 3200 reviews...
    Collected 3400 reviews...
    Collected 3600 reviews...
    Collected 3800 reviews...
    Collected 4000 reviews...
    Collected 4200 reviews...
    Collected 4400 reviews...
    Collected 4600 reviews...
    Collected 4800 reviews...
    Collected 5000 reviews...
    Collected 5200 reviews...
    Collected 5400 reviews...
    Collected 5600 reviews...
    Collected 5800 reviews...
    Collected 6000 reviews...
    Collected 6200 reviews...
    Collected 6400 reviews...
    Collected 6600 reviews...
    Collected 6800 reviews...
    Collected 7000 reviews...
    Collected 7200 reviews...
    Collected 7400 reviews...
    Collected 7600 reviews...
    Collected 7800 reviews...
    Collected 8000 reviews...
    Collected 8200 reviews...
    Collected 8400 reviews...
    Collected 8600 reviews...
    Collected 8800 reviews...
    Collected 9000 reviews...
    Collected 9200 reviews...
    Collected 9400 reviews...
    Collected 9600 reviews...
    Collected 9800 reviews...
    Collected 10000 reviews...
    Collected 10200 reviews...
    Collected 10400 reviews...
    Collected 10600 reviews...
    Collected 10800 reviews...
    Collected 11000 reviews...
    Collected 11200 reviews...
    Collected 11400 reviews...
    Collected 11600 reviews...
    Collected 11800 reviews...
    Collected 12000 reviews...
    Collected 12200 reviews...
    Collected 12400 reviews...
    Collected 12600 reviews...
    Collected 12800 reviews...
    Collected 13000 reviews...
    Collected 13200 reviews...
    Collected 13400 reviews...
    Collected 13600 reviews...
    Collected 13800 reviews...
    Collected 14000 reviews...
    Collected 14200 reviews...
    Collected 14400 reviews...
    Collected 14600 reviews...
    Collected 14800 reviews...
    Collected 15000 reviews...
    Collected 15200 reviews...
    Collected 15400 reviews...
    Collected 15600 reviews...
    Collected 15800 reviews...
    Collected 16000 reviews...
    Collected 16200 reviews...
    Collected 16400 reviews...
    Collected 16600 reviews...
    Collected 16800 reviews...
    Collected 17000 reviews...
    Collected 17200 reviews...
    Collected 17400 reviews...
    Collected 17600 reviews...
    Collected 17800 reviews...
    Collected 18000 reviews...
    Collected 18200 reviews...
    Collected 18400 reviews...
    Collected 18600 reviews...
    Collected 18800 reviews...
    Collected 19000 reviews...
    Collected 19200 reviews...
    Collected 19400 reviews...
    Collected 19600 reviews...
    Collected 19800 reviews...
    Collected 20000 reviews...
    Collected 20200 reviews...
    Collected 20400 reviews...
    Collected 20600 reviews...
    Collected 20800 reviews...
    Collected 21000 reviews...
    Collected 21200 reviews...
    Collected 21400 reviews...
    Collected 21600 reviews...
    Collected 21800 reviews...
    Collected 22000 reviews...
    Collected 22200 reviews...
    Collected 22400 reviews...
    Collected 22600 reviews...
    Collected 22800 reviews...
    Collected 23000 reviews...
    Collected 23200 reviews...
    Collected 23400 reviews...
    Collected 23600 reviews...
    Collected 23800 reviews...
    Collected 24000 reviews...
    Collected 24200 reviews...
    Collected 24400 reviews...
    Collected 24600 reviews...
    Collected 24800 reviews...
    Collected 25000 reviews...
    Collected 25200 reviews...
    Collected 25400 reviews...
    Collected 25600 reviews...
    Collected 25800 reviews...
    Collected 26000 reviews...
    Collected 26200 reviews...
    Collected 26400 reviews...
    Collected 26600 reviews...
    Collected 26800 reviews...
    Collected 27000 reviews...
    Collected 27200 reviews...
    Collected 27400 reviews...
    Collected 27600 reviews...
    Collected 27800 reviews...
    Collected 28000 reviews...
    Collected 28200 reviews...
    Collected 28400 reviews...
    Collected 28600 reviews...
    Collected 28800 reviews...
    Collected 29000 reviews...
    Collected 29200 reviews...
    Collected 29400 reviews...
    Collected 29600 reviews...
    Collected 29800 reviews...
    Collected 30000 reviews...
    Collected 30200 reviews...
    Collected 30400 reviews...
    Collected 30600 reviews...
    Collected 30800 reviews...
    Collected 31000 reviews...
    Collected 31200 reviews...
    Collected 31400 reviews...
    Collected 31600 reviews...
    Collected 31800 reviews...
    Collected 32000 reviews...
    Collected 32200 reviews...
    Collected 32400 reviews...
    Collected 32600 reviews...
    Collected 32800 reviews...
    Collected 33000 reviews...
    Collected 33200 reviews...
    Collected 33400 reviews...
    Collected 33600 reviews...
    Collected 33800 reviews...
    Collected 34000 reviews...
    Collected 34200 reviews...
    Collected 34400 reviews...
    Collected 34600 reviews...
    Collected 34800 reviews...
    Collected 35000 reviews...
    Collected 35200 reviews...
    Collected 35400 reviews...
    Collected 35600 reviews...
    Collected 35800 reviews...
    Collected 36000 reviews...
    Collected 36200 reviews...
    Collected 36400 reviews...
    Collected 36600 reviews...
    Collected 36800 reviews...
    Collected 37000 reviews...
    Collected 37200 reviews...
    Collected 37400 reviews...
    Collected 37600 reviews...
    Collected 37800 reviews...
    Collected 38000 reviews...
    Collected 38200 reviews...
    Collected 38400 reviews...
    Collected 38600 reviews...
    Collected 38800 reviews...
    Collected 39000 reviews...
    Collected 39200 reviews...
    Collected 39400 reviews...
    Collected 39600 reviews...
    Collected 39800 reviews...
    Collected 40000 reviews...
    Collected 40200 reviews...
    Collected 40400 reviews...
    Collected 40600 reviews...
    Collected 40800 reviews...
    Collected 41000 reviews...
    Collected 41200 reviews...
    Collected 41400 reviews...
    Collected 41600 reviews...
    Collected 41800 reviews...
    Collected 42000 reviews...
    Collected 42200 reviews...
    Collected 42400 reviews...
    Collected 42600 reviews...
    Collected 42800 reviews...
    Collected 43000 reviews...
    Collected 43200 reviews...
    Collected 43400 reviews...
    Collected 43600 reviews...
    Collected 43800 reviews...
    Collected 44000 reviews...
    Collected 44200 reviews...
    Collected 44400 reviews...
    Collected 44600 reviews...
    Collected 44800 reviews...
    Collected 45000 reviews...
    Collected 45200 reviews...
    Collected 45400 reviews...
    Collected 45600 reviews...
    Collected 45800 reviews...
    Collected 46000 reviews...
    Collected 46200 reviews...
    Collected 46400 reviews...
    Collected 46600 reviews...
    Collected 46800 reviews...
    Collected 47000 reviews...
    Collected 47200 reviews...
    Collected 47400 reviews...
    Collected 47600 reviews...
    Collected 47800 reviews...
    Collected 48000 reviews...
    Collected 48200 reviews...
    Collected 48400 reviews...
    Collected 48600 reviews...
    Collected 48800 reviews...
    Collected 49000 reviews...
    Collected 49200 reviews...
    Collected 49400 reviews...
    Collected 49600 reviews...
    Collected 49800 reviews...
    Collected 50000 reviews...
    Collected 50200 reviews...
    Collected 50400 reviews...
    Collected 50600 reviews...
    Collected 50800 reviews...
    Collected 51000 reviews...
    Collected 51200 reviews...
    Collected 51400 reviews...
    Collected 51600 reviews...
    Collected 51800 reviews...
    Collected 52000 reviews...
    Collected 52200 reviews...
    Collected 52400 reviews...
    Collected 52600 reviews...
    Collected 52800 reviews...
    Collected 53000 reviews...
    Collected 53200 reviews...
    Collected 53400 reviews...
    Collected 53600 reviews...
    Collected 53800 reviews...
    Collected 54000 reviews...
    Collected 54200 reviews...
    Collected 54400 reviews...
    Collected 54600 reviews...
    Collected 54800 reviews...
    Collected 55000 reviews...
    Collected 55200 reviews...
    Collected 55400 reviews...
    Collected 55600 reviews...
    Collected 55800 reviews...
    Collected 56000 reviews...
    Collected 56200 reviews...
    Collected 56400 reviews...
    Collected 56600 reviews...
    Collected 56800 reviews...
    Collected 57000 reviews...
    Collected 57200 reviews...
    Collected 57400 reviews...
    Collected 57600 reviews...
    Collected 57800 reviews...
    Collected 58000 reviews...
    Collected 58200 reviews...
    Collected 58400 reviews...
    Collected 58600 reviews...
    Collected 58800 reviews...
    Collected 59000 reviews...
    Collected 59200 reviews...
    Collected 59400 reviews...
    Collected 59600 reviews...
    Collected 59800 reviews...
    Collected 60000 reviews...
    Collected 60200 reviews...
    Collected 60400 reviews...
    Collected 60600 reviews...
    Collected 60800 reviews...
    Collected 61000 reviews...
    Collected 61200 reviews...
    Collected 61400 reviews...
    Collected 61600 reviews...
    Collected 61800 reviews...
    Collected 62000 reviews...
    Collected 62200 reviews...
    Collected 62400 reviews...
    Collected 62600 reviews...
    Collected 62800 reviews...
    Collected 63000 reviews...
    Collected 63200 reviews...
    Collected 63400 reviews...
    Collected 63600 reviews...
    Collected 63800 reviews...
    Collected 64000 reviews...
    Collected 64200 reviews...
    Collected 64400 reviews...
    Collected 64600 reviews...
    Collected 64800 reviews...
    Collected 65000 reviews...
    Collected 65200 reviews...
    Collected 65400 reviews...
    Collected 65600 reviews...
    Collected 65800 reviews...
    Collected 66000 reviews...
    Collected 66200 reviews...
    Collected 66400 reviews...
    Collected 66600 reviews...
    Collected 66800 reviews...
    Collected 67000 reviews...
    Collected 67200 reviews...
    Collected 67400 reviews...
    Collected 67600 reviews...
    Collected 67800 reviews...
    Collected 68000 reviews...
    Collected 68200 reviews...
    Collected 68400 reviews...
    Collected 68600 reviews...
    Collected 68800 reviews...
    Collected 69000 reviews...
    Collected 69200 reviews...
    Collected 69400 reviews...
    Collected 69600 reviews...
    Collected 69800 reviews...
    Collected 70000 reviews...
    Collected 70200 reviews...
    Collected 70400 reviews...
    Collected 70600 reviews...
    Collected 70800 reviews...
    Collected 71000 reviews...
    Collected 71200 reviews...
    Collected 71400 reviews...
    Collected 71600 reviews...
    Collected 71800 reviews...
    Collected 72000 reviews...
    Collected 72200 reviews...
    Collected 72400 reviews...
    Collected 72600 reviews...
    Collected 72800 reviews...
    Collected 73000 reviews...
    Collected 73200 reviews...
    Collected 73400 reviews...
    Collected 73600 reviews...
    Collected 73800 reviews...
    Collected 74000 reviews...
    Collected 74200 reviews...
    Collected 74400 reviews...
    Collected 74600 reviews...
    Collected 74800 reviews...
    Collected 75000 reviews...
    Collected 75200 reviews...
    Collected 75400 reviews...
    Collected 75600 reviews...
    Collected 75800 reviews...
    Collected 76000 reviews...
    Collected 76200 reviews...
    Collected 76400 reviews...
    Collected 76600 reviews...
    Collected 76800 reviews...
    Collected 77000 reviews...
    Collected 77200 reviews...
    Collected 77400 reviews...
    Collected 77600 reviews...
    Collected 77800 reviews...
    Collected 78000 reviews...
    Collected 78200 reviews...
    Collected 78400 reviews...
    Collected 78600 reviews...
    Collected 78800 reviews...
    Collected 79000 reviews...
    Collected 79200 reviews...
    Collected 79400 reviews...
    Collected 79600 reviews...
    Collected 79800 reviews...
    Collected 80000 reviews...
    Collected 80200 reviews...
    Collected 80400 reviews...
    Collected 80600 reviews...
    Collected 80800 reviews...
    Collected 81000 reviews...
    Collected 81200 reviews...
    Collected 81400 reviews...
    Collected 81600 reviews...
    Collected 81800 reviews...
    Collected 82000 reviews...
    Collected 82200 reviews...
    Collected 82400 reviews...
    Collected 82600 reviews...
    Collected 82800 reviews...
    Collected 83000 reviews...
    Collected 83200 reviews...
    Collected 83400 reviews...
    Collected 83600 reviews...
    Collected 83800 reviews...
    Collected 84000 reviews...
    Collected 84200 reviews...
    Collected 84400 reviews...
    Collected 84600 reviews...
    Collected 84800 reviews...
    Collected 85000 reviews...
    Collected 85200 reviews...
    Collected 85400 reviews...
    Collected 85600 reviews...
    Collected 85800 reviews...
    Collected 86000 reviews...
    Collected 86200 reviews...
    Collected 86400 reviews...
    Collected 86600 reviews...
    Collected 86800 reviews...
    Collected 87000 reviews...
    Collected 87200 reviews...
    Collected 87400 reviews...
    Collected 87600 reviews...
    Collected 87800 reviews...
    Collected 88000 reviews...
    Collected 88200 reviews...
    Collected 88400 reviews...
    Collected 88600 reviews...
    Collected 88800 reviews...
    Collected 89000 reviews...
    Collected 89200 reviews...
    Collected 89400 reviews...
    Collected 89600 reviews...
    Collected 89800 reviews...
    


```python

# Convert to DataFrame and save
df_revolut_en = pd.DataFrame(all_reviews_revolut_en)
```


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    Cell In[8], line 3
          1 # Convert to DataFrame and save
          2 df_revolut_en = pd.DataFrame(all_reviews_revolut_en)
    ----> 3 df_revolut_nl = df_revolut_nl.drop_duplicates(subset=['userName', 'content', 'at'])
    

    NameError: name 'df_revolut_nl' is not defined



```python
display(df_revolut_en)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>reviewId</th>
      <th>userName</th>
      <th>userImage</th>
      <th>content</th>
      <th>score</th>
      <th>thumbsUpCount</th>
      <th>reviewCreatedVersion</th>
      <th>at</th>
      <th>replyContent</th>
      <th>repliedAt</th>
      <th>appVersion</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ec851641-d8c1-4ae0-bf64-b977c4ae8eec</td>
      <td>Malvin Gora</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>excellent</td>
      <td>5</td>
      <td>0</td>
      <td>10.73</td>
      <td>2025-04-20 13:30:36</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.73</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7d15df26-5c07-4257-93bb-78b4be26ba0b</td>
      <td>Sunny The Cocktaiel</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>its good</td>
      <td>5</td>
      <td>0</td>
      <td>10.73</td>
      <td>2025-04-20 13:01:59</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.73</td>
    </tr>
    <tr>
      <th>2</th>
      <td>c8e7aa51-3993-41ba-b001-73950820e752</td>
      <td>kevin</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>custome service is absolutely non existent on ...</td>
      <td>1</td>
      <td>0</td>
      <td>10.73</td>
      <td>2025-04-20 13:01:00</td>
      <td>Hi. Sorry to hear that you have been unable to...</td>
      <td>2025-04-20 13:24:03</td>
      <td>10.73</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4ec1e4ca-eefb-48d9-8c28-6ef5d11b1eee</td>
      <td>Phillip mann</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>easy to navigate and loads of ways to earn and...</td>
      <td>5</td>
      <td>0</td>
      <td>10.73</td>
      <td>2025-04-20 12:57:27</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.73</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5ca8c157-7836-4e77-9b71-fd65716a098f</td>
      <td>Ghulamnabi Wafa</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>that I great</td>
      <td>5</td>
      <td>0</td>
      <td>10.67</td>
      <td>2025-04-20 12:44:18</td>
      <td>None</td>
      <td>NaT</td>
      <td>10.67</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>89995</th>
      <td>616d2ce1-140e-418f-98b5-7cc40f2e8ea8</td>
      <td>Solomon Ayofemi Moses</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>I can't sign up because there's no Nigeria in ...</td>
      <td>1</td>
      <td>0</td>
      <td>8.77.2</td>
      <td>2022-10-31 03:53:59</td>
      <td>Hi, thanks for the review. Unfortunately, Nige...</td>
      <td>2022-10-31 07:53:08</td>
      <td>8.77.2</td>
    </tr>
    <tr>
      <th>89996</th>
      <td>efe4bd84-55e7-4d93-bf51-c7516ce6aa13</td>
      <td>Behnam Farzi</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>it is the best bank I 've had ever</td>
      <td>5</td>
      <td>0</td>
      <td>8.76.1</td>
      <td>2022-10-31 03:33:10</td>
      <td>None</td>
      <td>NaT</td>
      <td>8.76.1</td>
    </tr>
    <tr>
      <th>89997</th>
      <td>2dbf4874-2cac-4653-895b-b46d8121a185</td>
      <td>Youscsef Tabouti</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>Good experience</td>
      <td>4</td>
      <td>0</td>
      <td>8.75</td>
      <td>2022-10-31 01:26:40</td>
      <td>None</td>
      <td>NaT</td>
      <td>8.75</td>
    </tr>
    <tr>
      <th>89998</th>
      <td>268177eb-aaad-48e5-b082-52998f618bd8</td>
      <td>Yakub Kamara</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Good just takesa whileto recieve mobey tgat ha...</td>
      <td>4</td>
      <td>0</td>
      <td>8.76.1</td>
      <td>2022-10-31 01:07:28</td>
      <td>None</td>
      <td>NaT</td>
      <td>8.76.1</td>
    </tr>
    <tr>
      <th>89999</th>
      <td>1c88035d-da01-4827-a363-9ef60e077944</td>
      <td>Sergiu Mihai Rotariu</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>I've been a Revolut customer for years. Now, a...</td>
      <td>1</td>
      <td>0</td>
      <td>8.76.1</td>
      <td>2022-10-31 00:48:05</td>
      <td>Hi, we're sorry to hear about your experience....</td>
      <td>2022-10-31 07:27:04</td>
      <td>8.76.1</td>
    </tr>
  </tbody>
</table>
<p>90000 rows × 11 columns</p>
</div>



```python
df_revolut_en.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\Revolut_en3_GooglePlay_reviews.xlsx", index=False)
```

N26


```python
# N26 app ID
app_id_n26_en = 'de.number26.android'
total_reviews_to_fetch_n26_en = 40000

all_reviews_n26_en = []
next_token_n26_en = None
prev_count_n26_en = 0

while len(all_reviews_n26_en) < total_reviews_to_fetch_n26_en:
    print(f"Collected {len(all_reviews_n26_en)} reviews...")

    result_n26_en, next_token_n26_en = reviews(
        app_id_n26_en,
        lang='en',        # English language
        country='nl',     # Netherlands
        sort=Sort.NEWEST,
        count=200,
        continuation_token=next_token_n26_en
    )

    if not result_n26_en:
        print("⚠️ No more reviews returned. Stopping.")
        break

    all_reviews_n26_en.extend(result_n26_en)

    if len(all_reviews_n26_en) == prev_count_n26_en:
        print("⚠️ Review count not increasing. Stopping.")
        break

    prev_count_n26_en = len(all_reviews_n26_en)

    if not next_token_n26_en:
        print("✅ No continuation token. All available reviews fetched.")
        break

```

    Collected 0 reviews...
    Collected 200 reviews...
    Collected 400 reviews...
    Collected 600 reviews...
    Collected 800 reviews...
    Collected 1000 reviews...
    Collected 1200 reviews...
    Collected 1400 reviews...
    Collected 1600 reviews...
    Collected 1800 reviews...
    Collected 2000 reviews...
    Collected 2200 reviews...
    Collected 2400 reviews...
    Collected 2600 reviews...
    Collected 2800 reviews...
    Collected 3000 reviews...
    Collected 3200 reviews...
    Collected 3400 reviews...
    Collected 3600 reviews...
    Collected 3800 reviews...
    Collected 4000 reviews...
    Collected 4200 reviews...
    Collected 4400 reviews...
    Collected 4600 reviews...
    Collected 4800 reviews...
    Collected 5000 reviews...
    Collected 5200 reviews...
    Collected 5400 reviews...
    Collected 5600 reviews...
    Collected 5800 reviews...
    Collected 6000 reviews...
    Collected 6200 reviews...
    Collected 6400 reviews...
    Collected 6600 reviews...
    Collected 6800 reviews...
    Collected 7000 reviews...
    Collected 7200 reviews...
    Collected 7400 reviews...
    Collected 7600 reviews...
    Collected 7800 reviews...
    Collected 8000 reviews...
    Collected 8200 reviews...
    Collected 8400 reviews...
    Collected 8600 reviews...
    Collected 8800 reviews...
    Collected 9000 reviews...
    Collected 9200 reviews...
    Collected 9400 reviews...
    Collected 9600 reviews...
    Collected 9800 reviews...
    Collected 10000 reviews...
    Collected 10200 reviews...
    Collected 10400 reviews...
    Collected 10600 reviews...
    Collected 10800 reviews...
    Collected 11000 reviews...
    Collected 11200 reviews...
    Collected 11400 reviews...
    Collected 11600 reviews...
    Collected 11800 reviews...
    Collected 12000 reviews...
    Collected 12200 reviews...
    Collected 12400 reviews...
    Collected 12600 reviews...
    Collected 12800 reviews...
    Collected 13000 reviews...
    Collected 13200 reviews...
    Collected 13400 reviews...
    Collected 13600 reviews...
    Collected 13717 reviews...
    ⚠️ No more reviews returned. Stopping.
    


```python
# Convert to DataFrame and save
df_n26_en = pd.DataFrame(all_reviews_n26_en)
df_n26_en = df_n26_en.drop_duplicates(subset=['userName', 'content', 'at'])

```


```python
display(df_n26_en)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>reviewId</th>
      <th>userName</th>
      <th>userImage</th>
      <th>content</th>
      <th>score</th>
      <th>thumbsUpCount</th>
      <th>reviewCreatedVersion</th>
      <th>at</th>
      <th>replyContent</th>
      <th>repliedAt</th>
      <th>appVersion</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>854544a9-d0d0-47ce-9bac-2100057ff888</td>
      <td>Amulya Dwivedi</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>what is the point of providing a watchlist fea...</td>
      <td>2</td>
      <td>1</td>
      <td>4.21</td>
      <td>2025-03-26 18:47:35</td>
      <td>None</td>
      <td>NaT</td>
      <td>4.21</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7cfb193f-c01e-428a-8af8-4b19f7c2a4d2</td>
      <td>Ivana Milosevic</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>So far good experience. But I do not have an o...</td>
      <td>3</td>
      <td>0</td>
      <td>4.21</td>
      <td>2025-03-26 13:39:52</td>
      <td>Hey Ivana, all transfers initiated from your N...</td>
      <td>2025-03-26 12:36:38</td>
      <td>4.21</td>
    </tr>
    <tr>
      <th>2</th>
      <td>e5c39be9-c397-4575-adec-943e8334bae0</td>
      <td>Frank Lindner</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>I thought to give up the n26 banking because o...</td>
      <td>4</td>
      <td>1</td>
      <td>4.21</td>
      <td>2025-03-26 09:18:48</td>
      <td>Hey Frank, we're sorry to hear that! You can e...</td>
      <td>2025-03-11 12:41:37</td>
      <td>4.21</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a9f8dc56-dc83-4856-87b1-a749e36b5837</td>
      <td>Samsu</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>App says it cannot be updated on my phone, so ...</td>
      <td>1</td>
      <td>0</td>
      <td>4.16</td>
      <td>2025-03-25 18:28:40</td>
      <td>Hey, you can check our system requirements her...</td>
      <td>2025-03-26 11:14:00</td>
      <td>4.16</td>
    </tr>
    <tr>
      <th>4</th>
      <td>f3e1064a-dd63-400d-be84-e97104f6a7d9</td>
      <td>Daniela Mbah</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>if it was possible would give it a 0 this peop...</td>
      <td>1</td>
      <td>0</td>
      <td>None</td>
      <td>2025-03-25 17:21:53</td>
      <td>Hey, as regulated bank, we're required to comp...</td>
      <td>2025-03-26 11:28:26</td>
      <td>None</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>13712</th>
      <td>6a6c523f-3107-4b81-82d0-2ded8aa15f2d</td>
      <td>A Google user</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Best online banking I'd tried</td>
      <td>5</td>
      <td>1</td>
      <td>1.2</td>
      <td>2015-02-12 00:17:23</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.2</td>
    </tr>
    <tr>
      <th>13713</th>
      <td>3adac9a3-b0f9-4249-be1c-7a437e3df703</td>
      <td>A Google user</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>The back-end provided functionality to this ap...</td>
      <td>5</td>
      <td>2</td>
      <td>1.0</td>
      <td>2015-02-02 10:58:40</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>13714</th>
      <td>0f68a93b-77d7-4bcd-8886-49fd8ba67678</td>
      <td>A Google user</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Super quick account set up (&amp;lt;10min) and ubi...</td>
      <td>5</td>
      <td>0</td>
      <td>1.0</td>
      <td>2015-01-28 08:13:05</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>13715</th>
      <td>77a2e55f-7e3f-4078-9df7-58da1fff8fb0</td>
      <td>A Google user</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>ich habe leider noch keinen invite code und wa...</td>
      <td>4</td>
      <td>1</td>
      <td>1.0</td>
      <td>2015-01-27 12:43:05</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>13716</th>
      <td>df58a41f-e3d2-47f1-91c6-d18552f4b144</td>
      <td>A Google user</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Perfect!!</td>
      <td>5</td>
      <td>1</td>
      <td>1.0</td>
      <td>2015-01-24 20:29:40</td>
      <td>None</td>
      <td>NaT</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
<p>13717 rows × 11 columns</p>
</div>



```python
df_n26_en.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\N26_en_GooglePlay_reviews.xlsx", index=False)
```


```python
# N26 app ID
app_id_n26_nl = 'de.number26.android'
total_reviews_to_fetch_n26_nl = 40000

all_reviews_n26_nl = []
next_token_n26_nl = None
prev_count_n26_nl = 0

while len(all_reviews_n26_nl) < total_reviews_to_fetch_n26_nl:
    print(f"Collected {len(all_reviews_n26_nl)} reviews...")

    result_n26_nl, next_token_n26_nl = reviews(
        app_id_n26_nl,
        lang='nl',        # Dutch language
        country='nl',     # Netherlands
        sort=Sort.NEWEST,
        count=200,
        continuation_token=next_token_n26_nl
    )

    if not result_n26_nl:
        print("⚠️ No more reviews returned. Stopping.")
        break

    all_reviews_n26_nl.extend(result_n26_nl)

    if len(all_reviews_n26_nl) == prev_count_n26_nl:
        print("⚠️ Review count not increasing. Stopping.")
        break

    prev_count_n26_nl = len(all_reviews_n26_nl)

    if not next_token_n26_nl:
        print("✅ No continuation token. All available reviews fetched.")
        break
```

    Collected 0 reviews...
    Collected 200 reviews...
    Collected 400 reviews...
    Collected 600 reviews...
    Collected 800 reviews...
    Collected 1000 reviews...
    Collected 1061 reviews...
    ⚠️ No more reviews returned. Stopping.
    


```python
# Convert to DataFrame and save
df_n26_nl = pd.DataFrame(all_reviews_n26_nl)
df_n26_nl = df_n26_nl.drop_duplicates(subset=['userName', 'content', 'at'])
```


```python
display(df_n26_nl)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>reviewId</th>
      <th>userName</th>
      <th>userImage</th>
      <th>content</th>
      <th>score</th>
      <th>thumbsUpCount</th>
      <th>reviewCreatedVersion</th>
      <th>at</th>
      <th>replyContent</th>
      <th>repliedAt</th>
      <th>appVersion</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>6f72ad20-4962-49a1-a5fd-7a34006cf51e</td>
      <td>Antonius Oosterwaal</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Hello my N 26 always worked great but now it w...</td>
      <td>1</td>
      <td>10</td>
      <td>4.20</td>
      <td>2025-03-13 19:48:08</td>
      <td>None</td>
      <td>NaT</td>
      <td>4.20</td>
    </tr>
    <tr>
      <th>1</th>
      <td>584ca31b-c357-46e8-bae3-731f2f969c8b</td>
      <td>Jan uit de Bulten</td>
      <td>https://play-lh.googleusercontent.com/a/ACg8oc...</td>
      <td>Zeer slecht, in geval van fraude willen ze nie...</td>
      <td>1</td>
      <td>3</td>
      <td>4.20</td>
      <td>2025-02-28 07:07:42</td>
      <td>None</td>
      <td>NaT</td>
      <td>4.20</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0cc2a34b-3e4e-4bfa-b1c0-cd373b0a4cc7</td>
      <td>Ryudo 300 (Ryudo300)</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Compleet drama om te installeren. Bij het gede...</td>
      <td>1</td>
      <td>1</td>
      <td>4.19</td>
      <td>2025-02-26 21:27:51</td>
      <td>None</td>
      <td>NaT</td>
      <td>4.19</td>
    </tr>
    <tr>
      <th>3</th>
      <td>7e8ebf28-f16d-4602-883d-55046ecdbd30</td>
      <td>Roger van Alphen</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Snel, professioneel en goedkoop. Uitstekende app</td>
      <td>5</td>
      <td>0</td>
      <td>4.19</td>
      <td>2025-02-20 17:14:34</td>
      <td>None</td>
      <td>NaT</td>
      <td>4.19</td>
    </tr>
    <tr>
      <th>4</th>
      <td>80f52dda-631d-4b81-84f2-e5afdfb54927</td>
      <td>Sammy koleilat Eldelbi</td>
      <td>https://play-lh.googleusercontent.com/a-/ALV-U...</td>
      <td>Good service</td>
      <td>5</td>
      <td>2</td>
      <td>4.19</td>
      <td>2025-02-16 21:00:19</td>
      <td>None</td>
      <td>NaT</td>
      <td>4.19</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>1056</th>
      <td>cbfeeb6b-2db9-4834-bda4-35bcc47c2d4a</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Easy and nice app, but after last update not a...</td>
      <td>3</td>
      <td>0</td>
      <td>2.11.0</td>
      <td>2016-10-01 15:17:54</td>
      <td>Hey, please set the language of your smartphon...</td>
      <td>2023-06-13 12:25:59</td>
      <td>2.11.0</td>
    </tr>
    <tr>
      <th>1057</th>
      <td>ed5fe8b6-51eb-435b-acfd-a5894fa725f0</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Absolutely amazing. No costs, almost live visi...</td>
      <td>5</td>
      <td>0</td>
      <td>2.8.1</td>
      <td>2016-09-10 03:16:34</td>
      <td>Hey Frank, thank you for your great rating! We...</td>
      <td>2016-09-12 10:24:46</td>
      <td>2.8.1</td>
    </tr>
    <tr>
      <th>1058</th>
      <td>6085f9a5-7a55-4ed4-b037-e6ba20e76a6f</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>I love this bank and their app, it's convenien...</td>
      <td>5</td>
      <td>1</td>
      <td>2.8.1</td>
      <td>2016-09-02 23:59:51</td>
      <td>Hey Gerben, thank you for your nice rating, we...</td>
      <td>2016-09-05 11:44:21</td>
      <td>2.8.1</td>
    </tr>
    <tr>
      <th>1059</th>
      <td>7f8cd9f9-28fa-49d0-b50e-3ca67def17dc</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Groundbreaking banking service. Banking has ne...</td>
      <td>5</td>
      <td>0</td>
      <td>2.5.0</td>
      <td>2016-05-19 22:19:58</td>
      <td>Hey Nandaka, thank you for your rating, we are...</td>
      <td>2016-05-20 08:53:19</td>
      <td>2.5.0</td>
    </tr>
    <tr>
      <th>1060</th>
      <td>a630d6c5-3abd-4d1f-abb1-2045e4020eee</td>
      <td>Een Google-gebruiker</td>
      <td>https://play-lh.googleusercontent.com/EGemoI2N...</td>
      <td>Great application, it actively informs you fro...</td>
      <td>5</td>
      <td>0</td>
      <td>2.4.1</td>
      <td>2016-04-13 12:13:29</td>
      <td>None</td>
      <td>NaT</td>
      <td>2.4.1</td>
    </tr>
  </tbody>
</table>
<p>1061 rows × 11 columns</p>
</div>



```python
df_n26_nl.to_excel(r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data\N26_nl_GooglePlay_reviews.xlsx", index=False)
```

# Merge data


```python
import pandas as pd

# Base path to your Excel files
base_path = r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data"

# Step 1: Load Excel files
n26_reviews = pd.read_excel(f"{base_path}\\N26_AppStore_reviews.xlsx")
mollie_reviews = pd.read_excel(f"{base_path}\\Mollie_AppStore_reviews.xlsx")
bunq_reviews = pd.read_excel(f"{base_path}\\Bunq_AppStore_reviews.xlsx")
revolut_reviews = pd.read_excel(f"{base_path}\\Revolut_AppStore_reviews.xlsx")

# Step 2: Add an "app_name" column
n26_reviews['app_name'] = 'N26'
mollie_reviews['app_name'] = 'Mollie'
bunq_reviews['app_name'] = 'Bunq'
revolut_reviews['app_name'] = 'Revolut'

# Step 3: Align columns
common_columns = ['date', 'userName', 'review', 'rating', 'developerResponse', 'app_name']

n26_reviews = n26_reviews[common_columns]
mollie_reviews = mollie_reviews[common_columns]
bunq_reviews = bunq_reviews[common_columns]
revolut_reviews = revolut_reviews[common_columns]

# Step 4: Merge all DataFrames
merged_reviews_AppStore = pd.concat([n26_reviews, mollie_reviews, bunq_reviews, revolut_reviews], ignore_index=True)

```


```python
display(merged_reviews_AppStore)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>userName</th>
      <th>review</th>
      <th>rating</th>
      <th>developerResponse</th>
      <th>app_name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2020-04-15 13:31:45</td>
      <td>olan.acc</td>
      <td>valeriol7860 de code om 15 euro op de kaart te...</td>
      <td>5</td>
      <td>NaN</td>
      <td>N26</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2019-06-14 20:13:34</td>
      <td>Chrisis8</td>
      <td>First bank that doesn’t charge you for any costs!</td>
      <td>5</td>
      <td>NaN</td>
      <td>N26</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2020-09-11 14:06:24</td>
      <td>Virgie1234</td>
      <td>Eigenlijk wilde ik N26 gebruiken als vaste las...</td>
      <td>3</td>
      <td>{'id': 21541639, 'body': "Hey, thank you for y...</td>
      <td>N26</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2018-02-19 19:45:25</td>
      <td>meeljeme</td>
      <td>Of you guys want to take off here in The Nethe...</td>
      <td>4</td>
      <td>NaN</td>
      <td>N26</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2018-05-15 18:01:27</td>
      <td>Rumbl3Shot</td>
      <td>Help me! I want to verify my account but when ...</td>
      <td>1</td>
      <td>{'id': 3541420, 'body': "Hey! We're sorry abou...</td>
      <td>N26</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2550</th>
      <td>2020-02-11 21:00:56</td>
      <td>user20120</td>
      <td>Na update van vandaag.  Kan ik niet neer inlog...</td>
      <td>1</td>
      <td>NaN</td>
      <td>Revolut</td>
    </tr>
    <tr>
      <th>2551</th>
      <td>2020-02-08 17:59:13</td>
      <td>vlad.82.82.82</td>
      <td>Account locked 2 month ago. Any information wh...</td>
      <td>1</td>
      <td>NaN</td>
      <td>Revolut</td>
    </tr>
    <tr>
      <th>2552</th>
      <td>2020-02-07 14:13:59</td>
      <td>Unnamed Resource</td>
      <td>Fix this, there are no other ways to add money...</td>
      <td>2</td>
      <td>NaN</td>
      <td>Revolut</td>
    </tr>
    <tr>
      <th>2553</th>
      <td>2020-01-29 12:35:37</td>
      <td>joelielie</td>
      <td>The app has a better lay-out than N26 to be ho...</td>
      <td>5</td>
      <td>NaN</td>
      <td>Revolut</td>
    </tr>
    <tr>
      <th>2554</th>
      <td>2020-01-30 19:09:01</td>
      <td>P0p@L!e</td>
      <td>I have my account blocked for 3 weeks and on l...</td>
      <td>1</td>
      <td>NaN</td>
      <td>Revolut</td>
    </tr>
  </tbody>
</table>
<p>2555 rows × 6 columns</p>
</div>



```python

# Optional: Save merged file to the same folder
merged_reviews_AppStore.to_excel(f"{base_path}\\Merged_AppStore_Reviews.xlsx", index=False)

```

google play


```python
# Base path to your Excel files
base_path = r"C:\Users\nklom\OneDrive\Pictures\Documents\Master\Thesis\Data"

# Step 1: Load Google Play Excel files
n26_nl = pd.read_excel(f"{base_path}\\N26_nl_GooglePlay_reviews.xlsx")
n26_en = pd.read_excel(f"{base_path}\\N26_en_GooglePlay_reviews.xlsx")
revolut_nl = pd.read_excel(f"{base_path}\\Revolut_nl_GooglePlay_reviews.xlsx")
revolut_en = pd.read_excel(f"{base_path}\\Revolut_en3_GooglePlay_reviews.xlsx")
mollie = pd.read_excel(f"{base_path}\\Mollie_GooglePlay_reviews.xlsx")
bunq = pd.read_excel(f"{base_path}\\Bunq_GooglePlay_reviews.xlsx")

# Step 2: Add app and language columns
n26_nl['app_name'] = 'N26';      n26_nl['language'] = 'nl'
n26_en['app_name'] = 'N26';      n26_en['language'] = 'en'
revolut_nl['app_name'] = 'Revolut'; revolut_nl['language'] = 'nl'
revolut_en['app_name'] = 'Revolut'; revolut_en['language'] = 'en'
mollie['app_name'] = 'Mollie';   mollie['language'] = 'mixed'
bunq['app_name'] = 'Bunq';       bunq['language'] = 'mixed'

# Step 3: Ensure consistent column names (you can adjust these based on your actual Excel structure)
common_columns = ['userName', 'content', 'score', 'at', 'app_name', 'language']

# Rename columns if needed
rename_map = {
    'content': 'content',
    'score': 'score',
    'userName': 'userName',
    'at': 'at'
}

# Apply renaming and select columns
for df in [n26_nl, n26_en, revolut_nl, revolut_en, mollie, bunq]:
    df.rename(columns=rename_map, inplace=True)
    df.drop_duplicates(subset=['userName', 'content', 'at'], inplace=True)
    
# Filter to common columns (if they exist in all files)
n26_nl = n26_nl[common_columns]
n26_en = n26_en[common_columns]
revolut_nl = revolut_nl[common_columns]
revolut_en = revolut_en[common_columns]
mollie = mollie[common_columns]
bunq = bunq[common_columns]

# Step 4: Merge all Google Play reviews
merged_gp_reviews = pd.concat([n26_nl, n26_en, revolut_nl, revolut_en, mollie, bunq], ignore_index=True)

```


```python
display(merged_gp_reviews)
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>userName</th>
      <th>content</th>
      <th>score</th>
      <th>at</th>
      <th>app_name</th>
      <th>language</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Antonius Oosterwaal</td>
      <td>Hello my N 26 always worked great but now it w...</td>
      <td>1</td>
      <td>2025-03-13 19:48:08</td>
      <td>N26</td>
      <td>nl</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Jan uit de Bulten</td>
      <td>Zeer slecht, in geval van fraude willen ze nie...</td>
      <td>1</td>
      <td>2025-02-28 07:07:42</td>
      <td>N26</td>
      <td>nl</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Ryudo 300 (Ryudo300)</td>
      <td>Compleet drama om te installeren. Bij het gede...</td>
      <td>1</td>
      <td>2025-02-26 21:27:51</td>
      <td>N26</td>
      <td>nl</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Roger van Alphen</td>
      <td>Snel, professioneel en goedkoop. Uitstekende app</td>
      <td>5</td>
      <td>2025-02-20 17:14:34</td>
      <td>N26</td>
      <td>nl</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Sammy koleilat Eldelbi</td>
      <td>Good service</td>
      <td>5</td>
      <td>2025-02-16 21:00:19</td>
      <td>N26</td>
      <td>nl</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>112305</th>
      <td>Een Google-gebruiker</td>
      <td>Registratie via website zou veel makkelijker z...</td>
      <td>2</td>
      <td>2015-11-25 13:12:54</td>
      <td>Bunq</td>
      <td>mixed</td>
    </tr>
    <tr>
      <th>112306</th>
      <td>Een Google-gebruiker</td>
      <td>Foto's van je id maken  Dat is jammer. Niet ec...</td>
      <td>2</td>
      <td>2015-11-25 13:09:27</td>
      <td>Bunq</td>
      <td>mixed</td>
    </tr>
    <tr>
      <th>112307</th>
      <td>Een Google-gebruiker</td>
      <td>super handige app, lekker overzichtelijk ook</td>
      <td>4</td>
      <td>2015-11-25 12:55:37</td>
      <td>Bunq</td>
      <td>mixed</td>
    </tr>
    <tr>
      <th>112308</th>
      <td>Een Google-gebruiker</td>
      <td>Mooie start bunqers! Registratie was appeltje-...</td>
      <td>4</td>
      <td>2015-11-25 12:16:11</td>
      <td>Bunq</td>
      <td>mixed</td>
    </tr>
    <tr>
      <th>112309</th>
      <td>Een Google-gebruiker</td>
      <td>Eindelijk een app waarmee je ècht meer kan dan...</td>
      <td>5</td>
      <td>2015-11-25 09:52:52</td>
      <td>Bunq</td>
      <td>mixed</td>
    </tr>
  </tbody>
</table>
<p>112310 rows × 6 columns</p>
</div>



```python
# Step 5: Save to a merged Excel file
merged_gp_reviews.to_excel(f"{base_path}\\Merged_GooglePlay_Review.xlsx", index=False)
```


```python

```
