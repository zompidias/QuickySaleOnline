using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace BusinessLayer
{
    public class ShoppingCart
    {
        string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        string ShoppingCartId { get; set; }
        public const string CartSessionKey = "CartId";

        public static ShoppingCart GetCart(HttpContextBase context)
        {
            var cart = new ShoppingCart();
            cart.ShoppingCartId = cart.GetCartId(context);
            return cart;
        }

        public static ShoppingCart GetCart(Controller controller)
        {
            return GetCart(controller.HttpContext);
        }
        public void AddToCart(FoodItem fooditem)
        {
            // Get the matching cart and album instances


            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddCartItems", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                SqlParameter paramFoodItemId = new SqlParameter();
                paramFoodItemId.ParameterName = "@FoodItemId";
                paramFoodItemId.Value = fooditem.FoodItemId;
                cmd.Parameters.Add(paramFoodItemId);

                SqlParameter paramCount = new SqlParameter();
                paramCount.ParameterName = "@Count";
                paramCount.Value = 1;
                cmd.Parameters.Add(paramCount);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            //storeDB.StoreCarts.Add(cartItem);

        }


        public int RemoveFromCart(int id)
        {
            // Get the cart
            int itemCount = 0;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spDeleteCartItem", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@RecordId";
                paramId.Value = id;
                cmd.Parameters.Add(paramId);

                cmd.Parameters.Add("@TotalCount", SqlDbType.VarChar, 150).Direction = ParameterDirection.Output;


                con.Open();
                cmd.ExecuteNonQuery();

                if (cmd.Parameters["@TotalCount"].Value.ToString() != "")
                {

                    itemCount = Convert.ToInt32(cmd.Parameters["@TotalCount"].Value.ToString());
                }
                else
                {
                    itemCount = 0;
                }

            }


            return itemCount;
        }
        public void EmptyCart()
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spEmptyCart", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        public List<StoreCart> GetCartItems(String ShoppingCartId)
        {
            // get
            //{
     

            List<StoreCart> Stores = new List<StoreCart>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetStoreCartItems", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    StoreCart store = new StoreCart();
                    store.FoodItemId = Convert.ToDecimal(rdr["FoodItemId"]);
                    store.Count = Convert.ToInt32(rdr["Count"].ToString());
                    store.RecordId = Convert.ToDecimal(rdr["RecordId"]);
                    store.StoreCartId = rdr["StoreCartId"].ToString();
                    //store.FoodName = rdr["FoodName"].ToString();

                    Stores.Add(store);
                }
                rdr.Dispose();
            }

            return Stores;
            //}
        }
        public int GetCount()
        {
            int total = 0;
   
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetTotalCartCount", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                cmd.Parameters.Add("@TotalCount", SqlDbType.VarChar, 150).Direction = ParameterDirection.Output;


                con.Open();
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@TotalCount"].Value.ToString() != "")
                {

                    total = Convert.ToInt32(cmd.Parameters["@TotalCount"].Value.ToString());
                }
                else
                {
                    total = 0;
                }

            }
            return total;
        }
        public decimal GetTotal()
        {
            decimal total = 0;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetTotalCartAmount", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                cmd.Parameters.Add("@TotalCount", SqlDbType.VarChar, 150).Direction = ParameterDirection.Output;


                con.Open();
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@TotalCount"].Value.ToString() != "")
                {

                    total = Convert.ToDecimal(cmd.Parameters["@TotalCount"].Value.ToString());
                }
                else
                {
                    total = 0;
                }
            }
            return total;
        }
        public decimal CreateOrder(string order, string username)
        {
             decimal number=0;
            var VcartItems = GetCartItems(order);
            // Iterate over the items in the cart, 
            // adding the order details for each
            foreach (var item in VcartItems)
            {
                 using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spAddOrderToCustomerDB", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlParameter paramCustomerDetailId = new SqlParameter();
                    paramCustomerDetailId.ParameterName = "@UserName";
                    paramCustomerDetailId.Value = username;
                    cmd.Parameters.Add(paramCustomerDetailId);

                    SqlParameter paramFoodItemId = new SqlParameter();
                    paramFoodItemId.ParameterName = "@FoodItemId";
                    paramFoodItemId.Value = item.FoodItemId;
                    cmd.Parameters.Add(paramFoodItemId);

                    SqlParameter paramQuantity = new SqlParameter();
                    paramQuantity.ParameterName = "@Quantity";
                    paramQuantity.Value = item.Count;
                    cmd.Parameters.Add(paramQuantity);

                    //SqlParameter paramUnitPrice = new SqlParameter();
                    //paramUnitPrice.ParameterName = "@UnitPrice";
                    //paramUnitPrice.Value = item.FoodItems.FoodCost;
                    //cmd.Parameters.Add(paramUnitPrice);

                    SqlParameter paramStoreCartId = new SqlParameter();
                    paramStoreCartId.ParameterName = "@StoreCartId";
                    paramStoreCartId.Value = order;
                    cmd.Parameters.Add(paramStoreCartId);

                    con.Open();
                cmd.ExecuteNonQuery();
                 }
            }
            
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spInsertIntoTblOrderNumber", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlParameter paramStoreCartId = new SqlParameter();
                    paramStoreCartId.ParameterName = "@StoreCartId";
                    paramStoreCartId.Value = order;
                    cmd.Parameters.Add(paramStoreCartId);

                    SqlParameter paramCustomerDetailId = new SqlParameter();
                    paramCustomerDetailId.ParameterName = "@UserName";
                    paramCustomerDetailId.Value = username;
                    cmd.Parameters.Add(paramCustomerDetailId);
                    con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    number = Convert.ToDecimal(rdr["OrderNumberId"]);
                }
                rdr.Dispose();
                }
                // Set the order total of the shopping cart
                //storeDB.CustomerOrderDetails.Add(orderDetail);

           //}
           
            return number;
        }

        public void CreateMember(CustomerDetail customer)
        {
               using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spAddMemberToCustomerDB", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlParameter paramUsername = new SqlParameter();
                    paramUsername.ParameterName = "@Username";
                    paramUsername.Value = customer.Email;
                    cmd.Parameters.Add(paramUsername);

                    SqlParameter parampassword = new SqlParameter();
                    parampassword.ParameterName = "@password";
                    parampassword.Value = customer.password;
                    cmd.Parameters.Add(parampassword);

                    SqlParameter paramFirstName = new SqlParameter();
                    paramFirstName.ParameterName = "@FirstName";
                    paramFirstName.Value = customer.FirstName;
                    cmd.Parameters.Add(paramFirstName);

                    SqlParameter paramLastName = new SqlParameter();
                    paramLastName.ParameterName = "@LastName";
                    paramLastName.Value = customer.LastName;
                    cmd.Parameters.Add(paramLastName);

                    SqlParameter paramAddress = new SqlParameter();
                    paramAddress.ParameterName = "@Address";
                    paramAddress.Value = customer.Address;
                    cmd.Parameters.Add(paramAddress);

                    SqlParameter paramStateId = new SqlParameter();
                    paramStateId.ParameterName = "@StateId";
                    paramStateId.Value = customer.StateId;
                    cmd.Parameters.Add(paramStateId);

                    SqlParameter paramPhone = new SqlParameter();
                    paramPhone.ParameterName = "@Phone";
                    paramPhone.Value = customer.Phone;
                    cmd.Parameters.Add(paramPhone);

                    SqlParameter paramEmail = new SqlParameter();
                    paramEmail.ParameterName = "@Email";
                    paramEmail.Value = customer.Email;
                    cmd.Parameters.Add(paramEmail);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    
                }
                
        }

        public bool CheckMembership(string username, string pwd)
        {
            bool result=false;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spConfirmMemberExists", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter paramUsername = new SqlParameter();
                paramUsername.ParameterName = "@Username";
                paramUsername.Value = username;
                cmd.Parameters.Add(paramUsername);

                SqlParameter parampassword = new SqlParameter();
                parampassword.ParameterName = "@password";
                parampassword.Value = pwd;
                cmd.Parameters.Add(parampassword);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    if(rdr["Email"].ToString()!= null || rdr["Email"].ToString()!= "")
                    {
                        result = true;
                    }
                    else { result = false; }
                }
                rdr.Dispose();
            }
            return result;
        }

        public string GetCartId(HttpContextBase context)
        {
            if (context.Session[CartSessionKey] == null)// || context.Session[CartSessionKey].ToString()=="")
            {
                if (!string.IsNullOrWhiteSpace(context.User.Identity.Name))
                {
                    context.Session[CartSessionKey] =
                        context.User.Identity.Name;
                }
                else
                {
                    // Generate a new random GUID using System.Guid class
                    Guid tempCartId = Guid.NewGuid();
                    // Send tempCartId back to client as a cookie
                    context.Session[CartSessionKey] = tempCartId.ToString();
                }
            }
            return context.Session[CartSessionKey].ToString();
        }
        // When a user has logged in, migrate their shopping cart to
        // be associated with their username
        public void MigrateCart(string userName)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spMigrateCart", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramuserName = new SqlParameter();
                paramuserName.ParameterName = "@userName";
                paramuserName.Value = userName;
                cmd.Parameters.Add(paramuserName);

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@ShoppingCartId";
                paramStoreCartId.Value = ShoppingCartId;
                cmd.Parameters.Add(paramStoreCartId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        public string getUserNameAfterCheckOut(string cartId){
            string username = null;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetUserNameAfterCheckOut", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@cartId";
                paramStoreCartId.Value = cartId;
                cmd.Parameters.Add(paramStoreCartId);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {

                    username = rdr["StateId"].ToString();
                }
                rdr.Dispose();
            }
            return username;
        }

       
        public void DeleteCartItemFromDB(decimal id)
        {
            string connectionString =
                    ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spDeleteOneCartItem", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@RecordId";
                paramId.Value = id;
                cmd.Parameters.Add(paramId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void IncreaseCartItemFromDB(decimal id)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spIncreaseOneCartItem", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@RecordId";
                paramId.Value = id;
                cmd.Parameters.Add(paramId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void DecreaseCartItemFromDB(decimal id)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spDecreaseOneCartItem", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@RecordId";
                paramId.Value = id;
                cmd.Parameters.Add(paramId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public string GetLoginDetail(string cartid)
        {
            string UserName = null;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetLoginDetail", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = cartid;
                cmd.Parameters.Add(paramStoreCartId);

                cmd.Parameters.Add("@UserName", SqlDbType.VarChar, 150).Direction = ParameterDirection.Output;


                con.Open();
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@UserName"].Value.ToString() != "")
                {

                    UserName = cmd.Parameters["@UserName"].Value.ToString();
                }
                else
                {
                    UserName = "Guest";
                }

            }
            return UserName;
        }

        public void AddGuestBrowserTotblUserProfile(string cartid)
        {
            //var cart = ShoppingCart.GetCart(this.HttpContext);
            //var cartid = GetCartId(this.HttpContext);
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddGuestLoginDetail", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = cartid;
                cmd.Parameters.Add(paramStoreCartId);

                con.Open();
                cmd.ExecuteNonQuery();
                

            }
        }

        public bool ConfirmMemberisLoggedIn(string cartid)
        {
            //var cart = ShoppingCart.GetCart(this.HttpContext);
            //var cartid = GetCartId(this.HttpContext);
            bool res = false;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spConfirmAlreadyLoggedIN", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = cartid;
                cmd.Parameters.Add(paramStoreCartId);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    if (rdr["StoreCartId"].ToString() != "")
                    {

                        res = true;
                    }
                    else
                    {
                        res = false;
                    }
                }
                rdr.Dispose();
           
            }

            return res;
        }

        

        public void UpdatetblUserProfileWithCurrentUserName(string UserName, string cartid)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spUpdateLoginDetailWithCurrentUserName", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramStoreCartId = new SqlParameter();
                paramStoreCartId.ParameterName = "@StoreCartId";
                paramStoreCartId.Value = cartid;
                cmd.Parameters.Add(paramStoreCartId);

                SqlParameter paramUserName = new SqlParameter();
                paramUserName.ParameterName = "@UserName";
                paramUserName.Value = UserName;
                cmd.Parameters.Add(paramUserName);

                con.Open();
                cmd.ExecuteNonQuery();


            }
        }

        public HttpContextBase HttpContext { get; set; }
    }
}