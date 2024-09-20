class SD_CLIENT {
  static final String DOMAIN_APP_API = "http://10.0.2.2:9999";

  //Login Api
  static final String api_loginurl = DOMAIN_APP_API + "/api/auth/login";
  static final String api_registerurl = DOMAIN_APP_API + "/api/auth/register";

  //Product
  static final String api_product = DOMAIN_APP_API + "/api/product";
  static final String api_product_bycategory = DOMAIN_APP_API + "/api/product/bycategory";
  static final String api_product_serachprice = DOMAIN_APP_API + "/api/product/searchprice";
  static final String api_detailproduct = DOMAIN_APP_API + "/api/product";
  //category
  static final String api_category = DOMAIN_APP_API + "/api/category";
  //ordercart
  static final String api_order = DOMAIN_APP_API + "/api/productcart";
  static final String api_createorder = DOMAIN_APP_API + "/api/productcart/createproductcart";
  static final String api_deleteorder = DOMAIN_APP_API + "/api/productcart";
  //checkout
  static final String api_checkoutorder = DOMAIN_APP_API + "/api/orders/createoders";
  //comment
  static final String api_comment = DOMAIN_APP_API + "/api/comment";
  static final String api_createcomment = DOMAIN_APP_API + "/api/comment/createcomment";
  //producthistory
  static final String api_producthistory = DOMAIN_APP_API + "/api/orders";
  static final String api_detailsorder = DOMAIN_APP_API + "/api/orders";
}
