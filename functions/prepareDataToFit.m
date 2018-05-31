function [ output_args ] = prepareDataToFit( btcusdavgdayprice, prehistoryprice, txdaycount, utxodaycount, wldbnkdevind )
% 0) import btcusd-avg-day-price.csv into workspace as btcusdavgdayprice
% table.

% 1) execute desired lines in command window to create data prepared for
% data analysis

% 2) create various arrays to fit price data to
time = btcusdavgdayprice{:,1};
timeJul2017 = btcusdavgdayprice{1:2103,1};
timeNov2017 = btcusdavgdayprice{1:2226,1};
price = btcusdavgdayprice{:,2};
priceJul2017 = btcusdavgdayprice{1:2103,2};
priceNov2017 = btcusdavgdayprice{1:2226,2};
btcusdavgprice([1,6,25,44:45,48:50,62,65,68:69,96,101],:) = []; % delete zeros

% 3) create various arrays to fit transaction, utxo data
%txTime = txdaycount{:,1};
%txs = txdaycount{:,2};
%utxos = utxodaycount{:,2};
tutxo = utxocounthistorydayavg{:,1};
cutxo = utxocounthistorydayavg{:,2};
twithutxo = txstotalwithunspentoutputsdayavg{:,1};
cwithutxo = txstotalwithunspentoutputsdayavg{:,2};
tpersec = txsacceptedpersecondweekavg{:,1};
cpersec = txsacceptedpersecondweekavg{:,2};
tmempool = txsinmempooldayavg{:,1};
cmempool = txsinmempooldayavg{:,2};

% 4) create array of combined prehistoryprice and avgdayprice
curvefitdata=outerjoin(prehistoryprice,btcusdavgdayprice,'MergeKeys', true);
curvefittime = curvefitdata{:,1};
curvefitprice = curvefitdata{:,2};

% 5) normalize times to help with determining coefficients a,b
timeFromPizza(:,1) = time(:,1) - 1.274e+09; % x=0 at 10,000BTC pizza unixtime
timeFromBitstamp(:,1) = time(:,1) - 1.316e+09 % x=0 at start of Bitstamp trading
timeNorm(:,1) = time(:,1) - 1.231e+09; % x=0 at first block mined unixtime

% 6) convert times to dates for plotting purposes
date = datetime(time,'ConvertFrom','posixtime');
dateJul2017 = datetime(timeJul2017,'ConvertFrom','posixtime');
dateFut = datetime(timeFut,'ConvertFrom','posixtime');

% 7) create arrays of World Bank Development Indicators data
di_mobcell = [wldbnkdevind{1,21:57}',wldbnkdevind{2,21:57}'];
di_intusers = [wldbnkdevind{1,34:57}',wldbnkdevind{4,34:57}'];
di_brdbnd = [wldbnkdevind{1,42:57}',wldbnkdevind{5,42:57}'];
di_mobcellexpdate = datetime(di_mobcell(:,1),12,31); % set dates to year ends
di_mobcelltime = posixtime(di_mobcellexpdate);
di_mobcellexptimesubset = di_mobcelltime(1:29);
di_mobcellexpsubset = di_mobcell(1:29,2);

% 8) traditional tech companies historical trading prices
aplDate = AAPL{:,1};
aplTime = posixtime(aplDate);
aplPrice = AAPL{:,2};
amzDate = AMZN{:,1};
amzTime = posixtime(amzDate);
amzPrice = AMZN{:,2};
gooDate = GOOG{:,1};
gooTime = posixtime(gooDate);
gooPrice = GOOG{:,2};
ibmDate = IBM{:,1};
ibmTime = posixtime(ibmDate);
ibmPrice = IBM{:,2};
msfDate = MSFT{:,1};
msfTime = posixtime(msfDate);
msfPrice = MSFT{:,2};
lnapl = log(aplPrice);
lnamz = log(amzPrice);
lngoo = log(gooPrice);
lnibm = log(ibmPrice);
lnmsf = log(msfPrice);

% 9) oxt.me statistics
timebdd = posixtime(statsbdd{:,1});
timeblocksize = posixtime(statsblocksize{:,1});
timenbtotaladdr = posixtime(statsnbtotaladdr{:,1});
timenbtx = posixtime(statsnbtx{:,1});
timenbutxo = posixtime(statsnbutxo{:,1});
timenewaddr = posixtime(statsnewaddr{:,1});
bdd = statsbdd{:,2};
blocksize = statsblocksize{:,2};
nbtotaladdr = statsnbtotaladdr{:,2};
nbtx = statsnbtx{:,2};
nbutxo = statsnbutxo{:,2};
newaddr = statsnewaddr{:,2};
lnbdd = log(bdd);
lnblocksize = log(blocksize);
lntotaladdr = log(nbtotaladdr);
lntx = log(nbtx);
lnutxo = log(nbutxo);
lnnewaddr = log(newaddr);
timeblocksizeOct2012 = timeblocksize(1:1373);
blocksizeOct2012 = blocksize(1:1373);
lnblocksizeOct2012 = log(blocksizeOct2012);

end

