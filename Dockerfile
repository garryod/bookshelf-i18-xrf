ARG PYTHON_VERSION=3.10

FROM python:${PYTHON_VERSION} as interactive

ENV WORKDIR=/environment
WORKDIR ${WORKDIR}

COPY . ${WORKDIR}

RUN pip install --upgrade .[interactive]

EXPOSE 8888

CMD ["jupyter-lab", "--ip=0.0.0.0", "--allow-root"]

FROM python:${PYTHON_VERSION}-slim as processing

ENV WORKDIR=/environment
WORKDIR ${WORKDIR}

COPY . ${WORKDIR}

RUN pip install --upgrade .[processing]

VOLUME /inputs /outputs

ENTRYPOINT ["papermill", "notebook.ipynb", "/outputs/notebook.ipynb", "--parameters", "OUTPUT_PREFIX", "/outputs",  "--parameters", "INPUT_PREFIX", "/inputs"]
