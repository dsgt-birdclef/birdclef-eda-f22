// const fetch = require("node-fetch");

module.exports = async () => {
  try {
    const res = await fetch(
      "https://storage.googleapis.com/birdclef-eda-f22/data/processed/mixit/listing.json"
    );
    let data = await res.json();
    console.log(data);

    return data;
  } catch (ex) {
    console.log(ex);
    return [];
  }
};
