'use strict';

const { execStdoutUtf8 } = require('../util/exec');

function getGitInfo() {
    var gitCommit = 'unknown';
    var gitDescribe = 'unknown';
    var gitBranch = 'unknown';

    try {
        gitCommit = execStdoutUtf8(['git', 'rev-parse', 'HEAD']).trim();
    } catch (e) {
        console.warn('Git metadata unavailable, using placeholders:', e.message);
    }
    try {
        gitDescribe = execStdoutUtf8(['git', 'describe', '--always', '--dirty']).trim();
    } catch (e) {
        console.warn('Git metadata unavailable, using placeholders:', e.message);
    }
    try {
        gitBranch = execStdoutUtf8(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).trim();
    } catch (e) {
        console.warn('Git metadata unavailable, using placeholders:', e.message);
    }
    return { gitCommit, gitDescribe, gitBranch };
}
exports.getGitInfo = getGitInfo;
