const express = require('express');
const { getTopHeadlines} =  require('../controllers/newsController');

const router = express.Router();

router.get('/top-headlines', getTopHeadlines);

module.exports = router;