from urllib.request import urlopen
from bs4 import BeautifulSoup
import pandas as pd

url_template = "https://www.sports-reference.com/cbb/players/{name}.html"

# Declare and create dataframes
draft_df = pd.DataFrame.from_csv("draft20092018.csv")
draft_df["Name"] = draft_df["Player"] # https://stackoverflow.com/questions/32675861/copy-all-values-in-a-column-to-a-new-column-in-a-pandas-dataframe
draft_df["School"] = draft_df["College"]
draft_df.set_index(keys = ["Name", "School"], inplace = True) # https://pandas.pydata.org/pandas-docs/version/0.21/generated/pandas.DataFrame.set_index.html
draft_df.dropna(axis = 0, how = 'any', inplace = True)

# draft_df = draft_df.iloc[:, 1:]
# Initiate dataframe and parameters
draft_dfNew = pd.DataFrame()
row = -1

# For each player drafted
for trueName in draft_df.iloc[:, 3]:  
    row += 1
    # Loop unless player url is invalid
    while True:
        i = 1
        
        # Basketball Reference had numerous typos in URL and inconsistent naming conventions
        if trueName == "Thomas Robinson":
            name = "thomas-robinson-2"
        elif trueName == "Bernard James":
            name = "bernard-james--1"
        elif trueName == "Kyle Anderson":
            name = "kyle-anderson-3"
        elif trueName == "Larry Nance Jr.":
            name = "larry-nance-2"
        elif trueName == "Stephen Zimmerman":
            name = "stephen-zimmermanjr-1"
        elif trueName == "Kay Felder":
            name = "kahlil-felder-1"
        elif trueName == "Bam Adebayo":
            name = "edrice-adebayo-1"
        else:
            name = trueName.replace(' ', '-').lower()
            name = name.replace('.', '').lower()
            name = name.replace("'", '').lower()
            name = name.replace("Jr.", '').lower()
            name = name.replace("III", '').lower()
            name += ("-" + str(1))
        url = url_template.format(name=name)  # get the url
        
        # Retrieve url
        html = urlopen(url) 
        # Create Beautiful Soup object
        soup = BeautifulSoup(html, 'html5lib') 
        
        # Grab column headers from website
        column_headers = [th.getText() for th in 
                      soup.findAll('tr', limit=1)[0].findAll('th')]
        
        # Grab seasonal and career data
        data_rows = soup.findAll('tr')[1:] 
            
        # season = ([th.getText() for th in data_rows[i].findAll('th')])
        
        player_data = [[td.getText() for td in data_rows[i].findAll('td')]
                    for i in range(len(data_rows))]
        season_data =[[th.getText() for th in data_rows[i].findAll('th')]
                    for i in range(len(data_rows))] 
        
        # Declare new_player_data df
        new_player_data = []
        
        for x in range(0, len(player_data)):
            # Remove empty season value due to stats trying to do career totals per each school for transfer students
            player_data[x].insert(0, season_data[x])
            new_player_data.append(player_data[x])
            if player_data[x][1] == "Overall":
                break
            # It seems as if break does not work if there is code after it, since it has a habit
            # of using code AFTER the break. It seems like it only stops the code AFTER the entire
            # current loop is finished. It does not seem to stop AT break.
        
        # Turn player data into a DataFrame
        player_df = pd.DataFrame(new_player_data, columns=column_headers[:])
        player_df["Name"] = trueName 
        
        """
        for i in range(0, len(player_df)):
            player_df.loc[i, "Name"] = trueName + str(i + 1)
        """
        
        # Grab correct players if they have the same name
        playerEndSeason = str(player_df.iloc[-2, 0]).rstrip(']').lstrip('[').strip("'").split("-", 1)[0]
        if int(playerEndSeason) + 1 != draft_df.iloc[row, 0]: # +1 is needed on left-hand side since 2007-08 -> 2007 -> 2007 + 1 -> 2008 | -1 is career, -2 is second to last year
            i += 1 
            break
        
        # https://stackoverflow.com/questions/39733141/how-to-drop-columns-with-empty-headers-in-pandas
        # player_df.drop(['', ''], axis=1, inplace = True) - Doesn't work
        # Website had very inconsistent stat boxes for players so drop empty columns
        if len(player_df.columns) > 30:
            player_df.drop(player_df.columns[-3], axis = 1, inplace = True)
  
        # Append to main df
        draft_dfNew = draft_dfNew.append(player_df, ignore_index = True)
        break
        # time.sleep(5)
    
draft_dfNew.head()
    
# Convert to proper data types
draft_dfNew = draft_dfNew.convert_objects(convert_numeric=True)


# Replace NaNs
draft_dfNew = draft_dfNew.fillna(0)

# Create CSV
draft_dfNew.to_csv("draft_data_2009_to_2018.csv")
