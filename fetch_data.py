import requests
import io
import pandas as pd
import numpy as np

raw = requests.get("https://www.aoml.noaa.gov/hrd/hurdat/hurdat2.html")  # get HURDAT2 data.

storms = []  # create array for where storms will be stored.
storm = {'header': None, 'data': []}  # create dict format of each storm (headers, data recordings of each storm)

for i, line in enumerate(io.StringIO(raw.text).readlines()):  # loop over raw (HURDAT2) data.
    if line[:2] == 'AL':
        storms.append(storm.copy())
        storm['header'] = line
        storm['data'] = []
    else:
        storm['data'].append(line)

storms = storms[1:]


storm_dataframes = []  # create array of dataframes of each storm.
for storm_dict in storms:  # loop over each storm in array of storms.
    storm_id, storm_name, storm_entries_n = storm_dict['header'].split(",")[:3]  # get id, name, and measurements of each storm.
    data = [[entry.strip() for entry in datum[:-1].split(",")] for datum in storm_dict['data']]  # split fields and remove newlines \n.

    frame = pd.DataFrame(data)  # create dataframe of storm.
    frame['id'] = storm_id  # write id of storm to dataframe
    frame['name'] = storm_name  # write name of storm to dataframe.

    storm_dataframes.append(frame)  # append dataframe of storm to array of dataframes of storms.

atlantic_storms = pd.concat(storm_dataframes)

atlantic_storms = atlantic_storms.reindex(columns=atlantic_storms.columns[-2:] | atlantic_storms.columns[:-2])

# name of column headers.
atlantic_storms.columns = [
        "id",  # id of storm.
        "name",  # name of storm
        "date",  # date of measurement
        "hours_minutes",  # hour:minutes of storm measurement.
        "record_identifier",  #
        "status_of_system",  # status of storm at time of measurement (tropical storm, hurricane)
        "latitude",  # latitude of storm (at time of measurement)
        "longitude",  # longitude of storm (at time of measurement)
        "maximum_sustained_wind_knots",  # maximum sustained winds of storm (in knots)
        "maximum_pressure",  # maximum pressure of storm.
        "34_kt_ne",
        "34_kt_se",
        "34_kt_sw",
        "34_kt_nw",
        "50_kt_ne",
        "50_kt_se",
        "50_kt_sw",
        "50_kt_nw",
        "64_kt_ne",
        "64_kt_se",
        "64_kt_sw",
        "64_kt_nw",
        "na"
]

del atlantic_storms['na']
pd.set_option('max_columns', None)
atlantic_storms = atlantic_storms.replace(to_replace='-999', value=np.nan)  # replaces -999 (NaN in data) with NaN


atlantic_storms['name'] = atlantic_storms['name'].map(lambda n: n.strip())

atlantic_storms.to_csv('filtered.csv')  # write filtered data to csv file.

