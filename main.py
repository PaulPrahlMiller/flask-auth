"""Main flask file."""
from flask import Flask, redirect, url_for, render_template, request, session

app = Flask(__name__)

app.secret_key = 's3cr3t'

users = {"paul": ['pass', 123456], "tian": ['pass2', 654321]}


@app.route('/')
def home():
    """Home page."""
    if 'username' not in session:
        return redirect(url_for('login'))
    else:
        user = session['username']
        return redirect(url_for('dashboard', user=user))


@app.route('/login', methods=['POST', 'GET'])
def login():
    """Login page."""
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        org_type = request.form['org_type']
        if auth_user(username, password, org_type):
            return redirect(url_for('dashboard', user=username))
        else:
            return render_template('login.html', error='error')

    if 'username' not in session:
        return render_template('login.html')
    else:
        return redirect(url_for('home'))


@app.route("/<user>")
def dashboard(user):
    """User page."""
    if session['org_type'] == 'restaurant':
        return render_template('restaurant.html', user=session['username'])

    return render_template('npo.html', user=session['username'])


@app.route("/logout", methods=['GET', 'POST'])
def logout():
    """Route to logout."""
    session.pop('username', None)
    session.pop('user_id', None)
    return redirect(url_for('home'))


def auth_user(username, password, org_type):
    """Authenticate user."""
    # Check org_type
    # Query db table same as org type
    # Get username, password, orgNumber
    #
    if users[username][0] == password:
        session['username'] = username
        session['org_type'] = org_type
        # session['org_number'] = database orgNumber
        return True
    else:
        return False


if __name__ == "__main__":
    app.run(debug=True)
