const axios = require ('axios');

const getTopHeadlines =  async (req,res) => {
    try{
        //optional query parameters 
        let category =  req.query.category || 'general';

        if(category.toLowerCase() === 'top news'){
            category = 'general';
        }

        const globalCountryCodes = ['in' , 'us', 'gb', 'au', 'ca'];
        const futures = [];
        

        for(const countryCode of globalCountryCodes){
            const url = `https://newsapi.org/v2/top-headlines`;
            futures.push(axios.get(url,{
                params : {
                    country: countryCode,
                    category: category,
                    apiKey: process.env.NEWS_API_KEY
                }
            }));
        }

        const results = await Promise.all(futures);

        //extracting articles from all responses and combine into one big array 
        let allArticles = [];
        results.forEach(response => {
            if(response.data && response.data.articles){
                allArticles = allArticles.concat(response.data.articles);
            }
        });
        
        //articles with no url
        allArticles = allArticles.filter(article => article.url);

        //array shuffle
        allArticles.sort(() => Math.random() - 0.5);

        res.status(200).json({articles : allArticles});
    }catch (error){
        console.error("Backend Error fetching news:",error.message);
        res.status(502).json({message : 'Failed to fetch news from upstream provider' })
    }
};


module.exports = { getTopHeadlines };