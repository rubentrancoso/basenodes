module.exports = function(app) {

    app.get('/api/hello', function(req, res) {
        var response = {
            message: 'hello'
        }
        res.send(response);
    })
}