const axios = require ('axios');

const getTopHeadlines =  async (req,res) => {
    try{
        //optional query parameters 
        const category =  req.query.category || 'general';
        const country = req.query.country || 'us';

        //fetch from real external NewsAPI 
        const response =  await axios.get(`https://newsapi.org/v2/top-headlines`,{
            params:{
                country: country,
                category: category,
                apiKey: process.env.NEWS_API_KEY
            }
        });

        res.status(200).json(response.data);
    }catch(error){
        console.error(error.message);
        //if newsapi fails
        res.status(502).json({ message: 'Failed to fetch news from upstream provider' });
    }
};

module.exports = { getTopHeadlines };