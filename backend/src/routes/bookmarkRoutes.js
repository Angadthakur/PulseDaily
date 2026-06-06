const express = require('express');
const { addBookmark , getUserBookmarks } =  require('../controllers/bookmarkController');
const {protect} =  require('../middleware/authMiddleware');

const router = express.Router();

router.use(protect);

router.post('/',  addBookmark);
router.get('/' , getUserBookmarks);

module.exports = router;