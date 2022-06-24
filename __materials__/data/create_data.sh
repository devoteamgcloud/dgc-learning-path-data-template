for i in $(seq -f "%02g" 1 30); do 
    echo $i;



    cat /Users/athevenot/github/dgc-learning-path/__materials__/data/bq-results-20220927-185136-1664304726415.json | grep "\"update_time\":\"2022-06-${i}" > 202206${i}/basket_202206${i}.json
    # exit 1
    # mkdir 202206${i};
    # cp /Users/athevenot/github/dgc-learning-path/__materials__/data/init/store_20220531.csv 202206${i}/store_202206${i}.csv;
    # touch 202206${i}/customer_202206${i}.csv;
    # touch 202206${i}/basket_202206${i}.json;
done