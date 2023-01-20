const EleventyFetch = require("@11ty/eleventy-fetch");

module.exports = async () => {
  let url =
    "https://storage.googleapis.com/birdclef-eda-f22/data/processed/mixit/listing.json";
  try {
    const data = await EleventyFetch(url, { type: "json" });
    return data;
  } catch (ex) {
    console.log(ex);
    return [];
  }
};
