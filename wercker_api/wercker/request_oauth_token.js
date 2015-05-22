'use strict';
var format   = require('util').format;

function request_oauth_token(user, pass, cb) {
    var post_obj, url;
    url = format('/api/%s/%s', this.api_version, this.constant.PATH_BASIC_ACCESS_TOKEN);
    post_obj = {
        "username": user,
        "password": pass,
        "oauthscope": 'cli'
    };

    this.req.do_post(url, post_obj, cb);
}

module.exports = request_oauth_token;
