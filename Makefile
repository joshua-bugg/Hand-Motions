# ----------------------------------
#          INSTALL & TEST
# ----------------------------------
install_requirements:
	@pip install -r requirements.txt

check_code:
	@flake8 scripts/* Hand-Motions/*.py

black:
	@black scripts/* Hand-Motions/*.py

test:
	@coverage run -m pytest tests/*.py
	@coverage report -m --omit="${VIRTUAL_ENV}/lib/python*"

ftest:
	@Write me

clean:
	@rm -f */version.txt
	@rm -f .coverage
	@rm -fr */__pycache__ */*.pyc __pycache__
	@rm -fr build dist
	@rm -fr Hand-Motions-*.dist-info
	@rm -fr Hand-Motions.egg-info

install:
	@pip install . -U

all: clean install test black check_code


uninstal:
	@python setup.py install --record files.txt
	@cat files.txt | xargs rm -rf
	@rm -f files.txt

count_lines:
	@find ./ -name '*.py' -exec  wc -l {} \; | sort -n| awk \
        '{printf "%4s %s\n", $$1, $$2}{s+=$$0}END{print s}'
	@echo ''
	@find ./scripts -name '*-*' -exec  wc -l {} \; | sort -n| awk \
		        '{printf "%4s %s\n", $$1, $$2}{s+=$$0}END{print s}'
	@echo ''
	@find ./tests -name '*.py' -exec  wc -l {} \; | sort -n| awk \
        '{printf "%4s %s\n", $$1, $$2}{s+=$$0}END{print s}'
	@echo ''

# ----------------------------------
#      UPLOAD PACKAGE TO PYPI
# ----------------------------------
PYPI_USERNAME=<AUTHOR>
build:
	@python setup.py sdist bdist_wheel

pypi_test:
	@twine upload -r testpypi dist/* -u $(PYPI_USERNAME)

pypi:
	@twine upload dist/* -u $(PYPI_USERNAME)






# project id
PROJECT_ID=hand-motions-306509  # Replace with your Project's ID

# bucket name
BUCKET_NAME='hand-motions' # Use your Project's name as it should be unique

REGION=europe-west1 # Choose your region https://cloud.google.com/storage/docs/locations#available_locations

set_project:
	@gcloud config set project ${PROJECT_ID}

create_bucket:
	@gsutil mb -l ${REGION} -p ${PROJECT_ID} gs://${BUCKET_NAME}



# path of the file to upload to gcp (the path of the file should be absolute or should match the directory where the make command is run)
LOCAL_PATH="/Users/kenzamandri/code/joshua-bugg/Hand-Motions/raw_date/test" # Replace with your local path to the `train_1k.csv` and make sure to put it between quotes
#LOCAL_PATH1="/Users/kenzamandri/code/joshua-bugg/Hand-Motions/raw_date/train" # Replace with your local path to the `train_1k.csv` and make sure to put it between quotes

# bucket directory in which to store the uploaded file (we choose to name this data as a convention)
BUCKET_FOLDER=data

# name for the uploaded file inside the bucket folder (here we choose to keep the name of the uploaded file)
# BUCKET_FILE_NAME=another_file_name_if_I_so_desire.csv
BUCKET_FILE_NAME=$(shell basename ${LOCAL_PATH})
#BUCKET_FILE_NAME1=$(shell basename ${LOCAL_PATH1})

upload_data:
	@gsutil cp ${LOCAL_PATH} gs://${BUCKET_NAME}/${BUCKET_FOLDER}/${BUCKET_FILE_NAME}
	#@gsutil cp ${LOCAL_PATH1} gs://${BUCKET_NAME}/${BUCKET_FOLDER}/${BUCKET_FILE_NAME1}
# @gsutil cp train_1k.csv gs://wagon-ml-my-bucket-name/data/train_1k.csv

run_api:
	uvicorn api.hand_motions_api:app --reload  # load web server with code autoreload

streamlit:
	-@streamlit run app.py
