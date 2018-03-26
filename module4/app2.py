import dash

from dash.dependencies import Input, Output, State

import dash_core_components as dcc

import dash_html_components as html

import dash_table_experiments as dt

import json

import pandas as pd

import numpy as np

import plotly

app = dash.Dash()

df = pd.read_csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module4/Data/riverkeeper_data_2013.csv")


# Remove sybmols of number
df['EnteroCount'] = df['EnteroCount'].map(lambda x: x.lstrip('><'))
df['EnteroCount'] = pd.to_numeric(df['EnteroCount'])

# Convert date of time 
df['Date'] = pd.to_datetime(df['Date'])

#df = df[df['EnteroCount'] == ]

app.layout = html.Div([

    html.H3('Selection location'),

    dt.DataTable(

        rows=df.to_dict('records'),



        # optional - sets the order of columns

        columns=sorted(df.columns),



        row_selectable=True,

        filterable=True,

        sortable=True,

        selected_row_indices=[0, 5, 10],

        id='datatable-entero'

    ),

    dcc.Graph(

        id='graph-entero'

    ),

], className="container")



@app.callback(

    Output('graph-entero', 'figure'),

    [Input('datatable-entero', 'rows'),

     Input('datatable-entero', 'selected_row_indices')])

def update_figure(rows, selected_row_indices):

    dff = pd.DataFrame(rows)

    return {

        'data': [{

            'y': dff['EnteroCount'],

            'y': dff['FourDayRainTotal'],

            'text': dff['Site'],

            'mode': 'markers',

            'textposition': 'top center',

            'selectedpoints': selected_row_indices,

            'marker': {

                'size': 10

            },



            'selected': {

                'marker': {

                    'line': {

                        'width': 1,

                        'color': 'rgb(0, 41, 124)'

                    },

                    'color': 'rgba(0, 41, 124, 0.7)',

                }

            },



            'unselected': {

                'marker': {

                    'line': {

                        'width': 0.5,

                        'color': 'rgb(0, 116, 217)'

                    },

                    'color': 'rgba(0, 116, 217, 0.5)',

                },



            }



        }],

        'layout': {'margin': {'l': 0, 'r': 0, 'b': 0, 't': 0}}

    }



    return fig





app.css.append_css({

    "external_url": "https://codepen.io/chriddyp/pen/bWLwgP.css"

})



if __name__ == '__main__':

    app.run_server(debug=True)
