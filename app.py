import streamlit as st
import pandas as pd
from PIL import Image

st.markdown('''

    # Welcome to Biohackers Wave Wizard

    ''')


image = Image.open('images/example_wave.png')
st.image(image, caption='Wave Snapshot', use_column_width=False)


def get_subject_data():
    print('Select Segment number')
    return pd.DataFrame({
          'subject_no': list(range(1, 13))
        })
subject_df = get_subject_data()

subject = st.sidebar.selectbox('Select Subject:', subject_df['subject_no'])

second_segment_number = st.number_input('Insert segment number')

'''You chose participant: '''
st.write(subject)

'''You chose segment'''
st.write(second_segment_number)

def predict(segment):
    # compute `wait_prediction` from `day_of_week` and `time`

    #model = joblib.load('model.joblib')
    #X_pred = model.predict(X)
    #prediction = float(X_pred[0])
    return "We predict this movement 'x'"

prediction = predict(second_segment_number)

st.write(prediction)


#function for creating line chart when we need it

# def get_line_chart_data():
#   print('get_line_chart_data called')
#    return pd.DataFrame(
#            np.random.randn(20, 3),
#            columns=['a', 'b', 'c']
#        )

#df = get_line_chart_data()

#st.line_chart(df)
