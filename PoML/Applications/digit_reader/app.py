# taken from https://community.canvaslms.com/thread/2595

from flask import Flask, render_template, url_for, request, jsonify
import numpy as np
from PIL import Image
import re
import io
import base64

app = Flask(__name__)
trainedLogReg_ = None


@app.route('/', methods=['GET', 'POST'])
def get_image():
    guess = 0
    if request.method == 'POST':
        # requests image from url
        img_size = 28, 28
        image_url = request.values['imageBase64']
        image_string = re.search(r'base64,(.*)', image_url).group(1)
        image_bytes = io.BytesIO(base64.b64decode(image_string))
        image = Image.open(image_bytes)
        image = image.resize(img_size, Image.ANTIALIAS)
        image = image.convert(mode="L", colors=128)
        image_array = np.asarray(image)
        image_array = image_array.flatten().reshape(1, -1)
        guess = int(trainedLogReg_.predict(image_array)[0])
        return jsonify(guess=guess)  # returns as jason format

    return render_template('index.html', guess=guess)


def train():
    # Download and sort the dataset
    print("Downloading MNIST data set")
    try:
        from sklearn.datasets import fetch_openml
        mnist = fetch_openml('mnist_784', version=1, cache=True)
        mnist.target = mnist.target.astype(np.int8)  # fetch_openml() returns targets as strings
    except ImportError:
        from sklearn.datasets import fetch_mldata
        mnist = fetch_mldata('MNIST original')
    mnist["data"], mnist["target"]
    from sklearn.utils import shuffle
    X, y = shuffle(mnist.data, mnist.target)
    print("MNIST data set downloaded and shuffled")

    print("Starting with model training.")
    from sklearn.linear_model import LogisticRegression
    lr = LogisticRegression(C=100.0, random_state=1, solver='lbfgs', multi_class='ovr', max_iter=100000)
    lr.fit(X, y)
    print("Finished with model training.")
    return lr


if __name__ == '__main__':
    if trainedLogReg_ is None:
        trainedLogReg_ = train()
    app.run(debug=True, use_reloader=False)
