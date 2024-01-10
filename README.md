# DigitalOcean (DO) Dynamic DNS (DDNS) Updater

A bash script that checks the IP set for an '_A_' record at DO DNS (via API) against the current public IP (via ifconfig.co) and updates DO DNS with the new IP if necessary.

## Docker Container Use

* Create an API Token at DigitalOcean
* Copy `.env.sample` to `.env` and edit values
* Build image
  * `docker build --tag do-ddns --load .`
    * See [Docker container build driver: --load](https://docs.docker.com/build/drivers/docker-container/#loading-to-local-image-store)
* Run container
  * To get a list of DNS record API IDs (_see example below_) for use in `.env`
    * `docker run -it --rm do-ddns list`
  * To Check/Update DNS
    * `docker run -it --rm do-ddns`

### Examples

* `docker run -it --rm do-ddns list`
    ```
    #API_ID#   @     SOA    1800
    #API_ID#   @     NS     ns1.digitalocean.com
    #API_ID#   @     NS     ns2.digitalocean.com
    #API_ID#   @     NS     ns3.digitalocean.com
    #API_ID#   @     A      xxx.xxx.xxx.xxx
    #API_ID#   www   CNAME  @
    #API_ID#   fqdn  A      xxx.xxx.xxx.xxx
    ```

* `docker run -it --rm do-ddns`
    ```
    Public (xxx.xxx.xxx.xxx) == DNS (xxx.xxx.xxx.xxx) - No Change
    ```
    _or_
    ```
    Public (xxx.xxx.xxx.xxx) <> DNS (xxx.xxx.xxx.xxx) - Setting fqdn.example.com = xxx.xxx.xxx.xxx (ID:#API_ID#)
    ```
