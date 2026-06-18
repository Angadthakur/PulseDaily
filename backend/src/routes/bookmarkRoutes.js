const express = require('express');
const { addBookmark , getUserBookmarks , removeBookmark} =  require('../controllers/bookmarkController');
const {protect} =  require('../middleware/authMiddleware');

const router = express.Router();

router.use(protect);

router.post('/',  addBookmark);
router.get('/' , getUserBookmarks);
router.delete('/', removeBookmark);

module.exports = router;