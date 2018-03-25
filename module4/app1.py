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
df.head()
df.tail()


app.layout = html.Div([

    html.H4('Enterococcus DataTable'),

    dt.DataTable(

        rows=df.to_dict('records'),



        # optional - sets the order of columns

        columns=sorted(df.columns),



        row_selectable=True,

        filterable=True,

        sortable=True,

        selected_row_indices=[],

        id='datatable-enterococcus'

    ),

    html.Div(id='selected-indexes'),

    dcc.Graph(

        id='graph-enterococcus'

    ),

], className="container")





@app.callback(

    Output('datatable-enterococcus', 'selected_row_indices'),

    [Input('graph-enterococcus', 'clickData')],

    [State('datatable-enterococcus', 'selected_row_indices')])

def update_selected_row_indices(clickData, selected_row_indices):

    if clickData:

        for point in clickData['points']:

            if point['pointNumber'] in selected_row_indices:

                selected_row_indices.remove(point['pointNumber'])

            else:

                selected_row_indices.append(point['pointNumber'])

    return selected_row_indices




@app.callback(

    Output('graph-enterococcus', 'figure'),

    [Input('datatable-enterococcus', 'rows'),

     Input('datatable-enterococcus', 'selected_row_indices')])

def update_figure(rows, selected_row_indices):

    dff = pd.DataFrame(rows)

    fig = plotly.tools.make_subplots(

        rows=3, cols=1,

        subplot_titles=('Enterococcus Count', 'Four Days Rain Total', 'Sample',),

        shared_xaxes=True)

    marker = {'color': ['#0074D9']*len(dff)}

    for i in (selected_row_indices or []):

        marker['color'][i] = '#FF851B'

    fig.append_trace({

        'x': dff['Site'],

        'y': dff['EnteroCount'],

        'type': 'bar',

        'marker': marker

    }, 1, 1)

    fig.append_trace({

        'x': dff['Site'],

        'y': dff['FourDayRainTotal'],

        'type': 'bar',

        'marker': marker

    }, 2, 1)

    fig.append_trace({

        'x': dff['Site'],

        'y': dff['SampleCount'],

        'type': 'bar',

        'marker': marker

    }, 3, 1)

    fig['layout']['showlegend'] = False

    fig['layout']['height'] = 800

    fig['layout']['margin'] = {

        'l': 40,

        'r': 10,

        't': 60,

        'b': 200

    }

    fig['layout']['yaxis3']['type'] = 'log'

    return fig





app.css.append_css({

    'external_url': 'https://codepen.io/chriddyp/pen/bWLwgP.css'

})



if __name__ == '__main__':

    app.run_server(debug=True)

