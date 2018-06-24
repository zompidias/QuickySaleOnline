using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
//using System.Data.OracleClient;


namespace BusinessLayer
{
    public class StoreBusinessLayer
    {
        string connectionString =
                   ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
        public IEnumerable<FoodItem> FoodItems
        {
            get
            {
               

                List<FoodItem> fooditems = new List<FoodItem>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllFoodItems", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        FoodItem fooditem = new FoodItem();
                        fooditem.FoodItemId = Convert.ToDecimal(rdr["FoodItemId"]);
                        fooditem.FoodName = rdr["FoodName"].ToString();
                        fooditem.FoodGroupId = Convert.ToDecimal(rdr["FoodGroupId"]);
                        fooditem.FoodCost = Convert.ToDecimal(rdr["FoodCost"].ToString());
                        fooditem.FoodWeightTypeId = Convert.ToDecimal(rdr["FoodWeightTypeId"]);
                        fooditem.SellerId = Convert.ToDecimal(rdr["SellerId"]);
                        fooditem.QuantityAvailable = Convert.ToInt32(rdr["QuantityAvailable"]);
                        fooditem.SubFoodGroupId = Convert.ToDecimal(rdr["SubFoodGroupId"]);
                        fooditem.FoodPicture = rdr["FoodPicture"].ToString();
                        fooditem.AlternateText = rdr["AlternateText"].ToString();
                        fooditem.BuyingPrice = Convert.ToDecimal(rdr["BuyingPrice"].ToString());
                        fooditems.Add(fooditem);
                    }
                    rdr.Dispose();
                }

                return fooditems;
            }
        }

        public IEnumerable<FoodGroup> FoodGroups
        {
            get
            {

                List<FoodGroup> foodgroups = new List<FoodGroup>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllFoodGroups", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        FoodGroup foodGroup = new FoodGroup();
                        foodGroup.FoodGroupId = Convert.ToDecimal(rdr["FoodGroupId"]);
                        foodGroup.FoodGroupName = rdr["FoodGroupName"].ToString();

                        foodgroups.Add(foodGroup);
                    }
                    rdr.Dispose();
                }

                return foodgroups;
            }
        }
        public IEnumerable<SubFoodGroup> SubFoodGroups
        {
            get
            {
  
                List<SubFoodGroup> foodgroups = new List<SubFoodGroup>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllSubFoodGroups", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        SubFoodGroup foodGroup = new SubFoodGroup();
                        foodGroup.SubFoodGroupId = Convert.ToDecimal(rdr["SubFoodGroupId"]);
                        foodGroup.SubFoodGroupName = rdr["SubFoodGroupName"].ToString();
                        foodGroup.FoodGroupId = Convert.ToDecimal(rdr["FoodGroupId"].ToString());
                        foodgroups.Add(foodGroup);
                    }
                    rdr.Dispose();
                }

                return foodgroups;
            }
        }
        public IEnumerable<FoodWeightType> FoodWeightTypes
        {
            get
            {
              List<FoodWeightType> foodgroups = new List<FoodWeightType>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllFoodWeightType", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        FoodWeightType foodGroup = new FoodWeightType();
                        foodGroup.FoodWeightTypeId = Convert.ToDecimal(rdr["FoodWeightTypeId"]);
                        foodGroup.FoodWeightTypeName = rdr["FoodWeightTypeName"].ToString();

                        foodgroups.Add(foodGroup);
                    }
                    rdr.Dispose();
                }

                return foodgroups;
            }
        }

        public IEnumerable<QSSellerDetail> SellerDetails
        {
            get
            {
 
                List<QSSellerDetail> foodgroups = new List<QSSellerDetail>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetSellerDetail", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                      
                        QSSellerDetail foodGroup = new QSSellerDetail();
                        foodGroup.SellerId = Convert.ToDecimal(rdr["SellerId"]);
                        foodGroup.SellerName = rdr["SellerName"].ToString();
                        foodGroup.SellerAccountName = rdr["SellerAccountName"].ToString();
                        foodGroup.SellerAccountNumber = rdr["SellerAccountNumber"].ToString();
                        foodGroup.BankId = Convert.ToDecimal(rdr["BankId"].ToString());
                        foodGroup.SellerEmail = rdr["SellerEmail"].ToString();
                        foodGroup.SellerPhoneNumber = rdr["SellerPhoneNumber"].ToString();
                        foodGroup.SellerAddress = rdr["SellerAddress"].ToString();
                        foodGroup.SellerState = rdr["SellerState"].ToString();

                        foodgroups.Add(foodGroup);
                    }
                    rdr.Dispose();
                }

                return foodgroups;
            }
        }

        public IEnumerable<State> States
        {
            get
            {

                List<State> states = new List<State>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetStates", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        State meState = new State();
                        meState.StateId = Convert.ToDecimal(rdr["StateId"]);
                        meState.StateName = rdr["StateName"].ToString();

                        states.Add(meState);
                    }
                    rdr.Dispose();
                }

                return states;
            }
        }

        public IEnumerable<BankDetails> BankDetails
        {
            get
            {

                List<BankDetails> foodgroups = new List<BankDetails>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllBankDetails", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        BankDetails foodGroup = new BankDetails();
                        foodGroup.BankId = Convert.ToDecimal(rdr["BankId"]);
                        foodGroup.BankName = rdr["BankName"].ToString();

                        foodgroups.Add(foodGroup);
                    }
                    rdr.Dispose();
                }

                return foodgroups;
            }
        }

        public IEnumerable<CustomerDetail> CustomerDetails
        {
            get
            {

                List<CustomerDetail> foodgroups = new List<CustomerDetail>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllCustomerDetails", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        CustomerDetail foodGroup = new CustomerDetail();
                        foodGroup.Address = rdr["Address"].ToString();
                        foodGroup.Email = rdr["Email"].ToString();
                        foodGroup.FirstName = rdr["FirstName"].ToString();
                        foodGroup.LastName = rdr["LastName"].ToString();
                        foodGroup.password = rdr["password"].ToString();
                        foodGroup.Phone = rdr["Phone"].ToString();
                        foodGroup.StateId = Convert.ToDecimal(rdr["StateId"].ToString());

                        foodgroups.Add(foodGroup);
                    }
                    rdr.Dispose();
                }

                return foodgroups;
            }
        }
        public void AddFoodItemToDB(FoodItem employee)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddFoodItems", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.FoodName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramFoodGrpId = new SqlParameter();
                paramFoodGrpId.ParameterName = "@FoodGroupId";
                paramFoodGrpId.Value = employee.FoodGroupId;
                cmd.Parameters.Add(paramFoodGrpId);

                SqlParameter paramFoodCost = new SqlParameter();
                paramFoodCost.ParameterName = "@FoodCost";
                paramFoodCost.Value = employee.FoodCost;
                cmd.Parameters.Add(paramFoodCost);

                SqlParameter paramFoodWeigth = new SqlParameter();
                paramFoodWeigth.ParameterName = "@FoodWeightTypeId";
                paramFoodWeigth.Value = employee.FoodWeightTypeId;
                cmd.Parameters.Add(paramFoodWeigth);

                SqlParameter paramQtyAvailable = new SqlParameter();
                paramQtyAvailable.ParameterName = "@QuantityAvailable";
                paramQtyAvailable.Value = employee.QuantityAvailable;
                cmd.Parameters.Add(paramQtyAvailable);

                SqlParameter paramSellerId = new SqlParameter();
                paramSellerId.ParameterName = "@SellerId";
                paramSellerId.Value = employee.SellerId;
                cmd.Parameters.Add(paramSellerId);

                SqlParameter paramSubGrpId = new SqlParameter();
                paramSubGrpId.ParameterName = "@SubFoodGroupId";
                paramSubGrpId.Value = employee.SubFoodGroupId;
                cmd.Parameters.Add(paramSubGrpId);

                SqlParameter paramBuyingPrice = new SqlParameter();
                paramBuyingPrice.ParameterName = "@BuyingPrice";
                paramBuyingPrice.Value = employee.BuyingPrice;
                cmd.Parameters.Add(paramBuyingPrice);

                SqlParameter paramAlternateText = new SqlParameter();
                paramAlternateText.ParameterName = "@AlternteText";
                paramAlternateText.Value = employee.AlternateText;
                cmd.Parameters.Add(paramAlternateText);


                SqlParameter paramFoodPicture = new SqlParameter();
                paramFoodPicture.ParameterName = "@FoodPicture";
                paramFoodPicture.Value = employee.FoodPicture;
                cmd.Parameters.Add(paramFoodPicture);

                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public void AddFoodGroupToDB(FoodGroup employee)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddFoodGroup", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.FoodGroupName;
                cmd.Parameters.Add(paramFoodName);

                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public void AddSubFoodGroupToDB(SubFoodGroup employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddSubFoodGroup", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.SubFoodGroupName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramFoodGroupId = new SqlParameter();
                paramFoodGroupId.ParameterName = "@FoodGroupId";
                paramFoodGroupId.Value = employee.FoodGroupId;
                cmd.Parameters.Add(paramFoodGroupId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public void AddFoodWeightTypeToDB(FoodWeightType employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddFoodWeightType", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.FoodWeightTypeName;
                cmd.Parameters.Add(paramFoodName);

                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public void AddQSSellerDetailToDB(QSSellerDetail employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddSellerDetail", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@SellerName";
                paramFoodName.Value = employee.SellerName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramSellerState = new SqlParameter();
                paramSellerState.ParameterName = "@SellerState";
                paramSellerState.Value = employee.SellerState;
                cmd.Parameters.Add(paramSellerState);

                SqlParameter paramSellerAddress = new SqlParameter();
                paramSellerAddress.ParameterName = "@SellerAddress";
                paramSellerAddress.Value = employee.SellerAddress;
                cmd.Parameters.Add(paramSellerAddress);

                SqlParameter paramSellerPhoneNumber = new SqlParameter();
                paramSellerPhoneNumber.ParameterName = "@SellerPhoneNumber";
                paramSellerPhoneNumber.Value = employee.SellerPhoneNumber;
                cmd.Parameters.Add(paramSellerPhoneNumber);

                SqlParameter paramSellerEmail = new SqlParameter();
                paramSellerEmail.ParameterName = "@SellerEmail";
                paramSellerEmail.Value = employee.SellerEmail;
                cmd.Parameters.Add(paramSellerEmail);

                SqlParameter paramSellerAccountNumber = new SqlParameter();
                paramSellerAccountNumber.ParameterName = "@SellerAccountNumber";
                paramSellerAccountNumber.Value = employee.SellerAccountNumber;
                cmd.Parameters.Add(paramSellerAccountNumber);

                SqlParameter paramBankId = new SqlParameter();
                paramBankId.ParameterName = "@BankId";
                paramBankId.Value = employee.BankId;
                cmd.Parameters.Add(paramBankId);

                SqlParameter paramSellerAccountName = new SqlParameter();
                paramSellerAccountName.ParameterName = "@SellerAccountName";
                paramSellerAccountName.Value = employee.SellerAccountName;
                cmd.Parameters.Add(paramSellerAccountName);

                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public void SaveChangesFoodItemToDB(FoodItem employee)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spSaveChangesFoodItem", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@FoodItemId";
                paramId.Value = employee.FoodItemId;
                cmd.Parameters.Add(paramId);

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.FoodName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramFoodGrpId = new SqlParameter();
                paramFoodGrpId.ParameterName = "@FoodGroupId";
                paramFoodGrpId.Value = employee.FoodGroupId;
                cmd.Parameters.Add(paramFoodGrpId);

                SqlParameter paramFoodCost = new SqlParameter();
                paramFoodCost.ParameterName = "@FoodCost";
                paramFoodCost.Value = employee.FoodCost;
                cmd.Parameters.Add(paramFoodCost);

                SqlParameter paramFoodWeigth = new SqlParameter();
                paramFoodWeigth.ParameterName = "@FoodWeightTypeId";
                paramFoodWeigth.Value = employee.FoodWeightTypeId;
                cmd.Parameters.Add(paramFoodWeigth);

                SqlParameter paramQtyAvailable = new SqlParameter();
                paramQtyAvailable.ParameterName = "@QuantityAvailable";
                paramQtyAvailable.Value = employee.QuantityAvailable;
                cmd.Parameters.Add(paramQtyAvailable);

                SqlParameter paramSellerId = new SqlParameter();
                paramSellerId.ParameterName = "@SellerId";
                paramSellerId.Value = employee.SellerId;
                cmd.Parameters.Add(paramSellerId);

                SqlParameter paramSubGrpId = new SqlParameter();
                paramSubGrpId.ParameterName = "@SubFoodGroupId";
                paramSubGrpId.Value = employee.SubFoodGroupId;
                cmd.Parameters.Add(paramSubGrpId);

                SqlParameter paramFoodPicture = new SqlParameter();
                paramFoodPicture.ParameterName = "@FoodPicture";
                paramFoodPicture.Value = employee.FoodPicture;
                cmd.Parameters.Add(paramFoodPicture);
                SqlParameter paramBuyingPrice = new SqlParameter();
                paramBuyingPrice.ParameterName = "@BuyingPrice";
                paramBuyingPrice.Value = employee.BuyingPrice;
                cmd.Parameters.Add(paramBuyingPrice);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void SaveChangesFoodGroupToDB(FoodGroup employee)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spSaveChangesFoodGroup", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.FoodGroupName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@FoodGroupId";
                paramId.Value = employee.FoodGroupId;
                cmd.Parameters.Add(paramId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void SaveChangesSubFoodGroupToDB(SubFoodGroup employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spSaveChangesSubFoodGroup", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.SubFoodGroupName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@FoodGroupId";
                paramId.Value = employee.SubFoodGroupId;
                cmd.Parameters.Add(paramId);

                SqlParameter FoodGrpparamId = new SqlParameter();
                FoodGrpparamId.ParameterName = "@GroupId";
                FoodGrpparamId.Value = employee.FoodGroupId;
                cmd.Parameters.Add(FoodGrpparamId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void SaveChangesFoodWeightTypeToDB(FoodWeightType employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spSaveChangesFoodWeightType", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = employee.FoodWeightTypeName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@FoodGroupId";
                paramId.Value = employee.FoodWeightTypeId;
                cmd.Parameters.Add(paramId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void SaveChangesQSSellerDetailToDB(QSSellerDetail employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spSaveChangesSellerDetail", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@SellerName";
                paramFoodName.Value = employee.SellerName;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@SellerId";
                paramId.Value = employee.SellerId;
                cmd.Parameters.Add(paramId);

                SqlParameter paramSellerState = new SqlParameter();
                paramSellerState.ParameterName = "@SellerState";
                paramSellerState.Value = employee.SellerState;
                cmd.Parameters.Add(paramSellerState);

                SqlParameter paramSellerAddress = new SqlParameter();
                paramSellerAddress.ParameterName = "@SellerAddress";
                paramSellerAddress.Value = employee.SellerAddress;
                cmd.Parameters.Add(paramSellerAddress);

                SqlParameter paramSellerPhoneNumber = new SqlParameter();
                paramSellerPhoneNumber.ParameterName = "@SellerPhoneNumber";
                paramSellerPhoneNumber.Value = employee.SellerPhoneNumber;
                cmd.Parameters.Add(paramSellerPhoneNumber);

                SqlParameter paramSellerEmail = new SqlParameter();
                paramSellerEmail.ParameterName = "@SellerEmail";
                paramSellerEmail.Value = employee.SellerEmail;
                cmd.Parameters.Add(paramSellerEmail);

                SqlParameter paramSellerAccountNumber = new SqlParameter();
                paramSellerAccountNumber.ParameterName = "@SellerAccountNumber";
                paramSellerAccountNumber.Value = employee.SellerAccountNumber;
                cmd.Parameters.Add(paramSellerAccountNumber);

                SqlParameter paramBankId = new SqlParameter();
                paramBankId.ParameterName = "@BankId";
                paramBankId.Value = employee.BankId;
                cmd.Parameters.Add(paramBankId);

                SqlParameter paramSellerAccountName = new SqlParameter();
                paramSellerAccountName.ParameterName = "@SellerAccountName";
                paramSellerAccountName.Value = employee.SellerAccountName;
                cmd.Parameters.Add(paramSellerAccountName);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void SaveChangesCustomerDetailToDB(CustomerDetail employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spSaveChangesCustomerDetail", con);
                cmd.CommandType = CommandType.StoredProcedure;
 
	          SqlParameter parampassword = new SqlParameter();
                parampassword.ParameterName = "@password";
                parampassword.Value = employee.password;
                cmd.Parameters.Add(parampassword);

                SqlParameter paramFirstName = new SqlParameter();
                paramFirstName.ParameterName = "@FirstName";
                paramFirstName.Value = employee.FirstName;
                cmd.Parameters.Add(paramFirstName);

                SqlParameter paramLastName = new SqlParameter();
                paramLastName.ParameterName = "@LastName";
                paramLastName.Value = employee.LastName;
                cmd.Parameters.Add(paramLastName);

                SqlParameter paramAddress = new SqlParameter();
                paramAddress.ParameterName = "@Address";
                paramAddress.Value = employee.Address;
                cmd.Parameters.Add(paramAddress);

                SqlParameter paramStateId = new SqlParameter();
                paramStateId.ParameterName = "@StateId";
                paramStateId.Value = employee.StateId;
                cmd.Parameters.Add(paramStateId);

                SqlParameter paramPhone = new SqlParameter();
                paramPhone.ParameterName = "@Phone";
                paramPhone.Value = employee.Phone;
                cmd.Parameters.Add(paramPhone);

                SqlParameter paramEmail = new SqlParameter();
                paramEmail.ParameterName = "@Email";
                paramEmail.Value = employee.Email;
                cmd.Parameters.Add(paramEmail);

                
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void DeleteFoodItemFromDB(decimal id)
        {
 
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spDeleteFoodItem", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramId = new SqlParameter();
                paramId.ParameterName = "@FoodItemId";
                paramId.Value = id;
                cmd.Parameters.Add(paramId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public IEnumerable<FoodItem> GetSearchRequest(string str)
        {

 
            List<FoodItem> fooditems = new List<FoodItem>();
            var strings = str.Split(' ');

            foreach (var splitString in strings)
            {


            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetSearchFoodItems", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@FoodName";
                paramFoodName.Value = splitString;
                cmd.Parameters.Add(paramFoodName);

                con.Open();
               // cmd.ExecuteNonQuery();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    FoodItem fooditem = new FoodItem();
                    fooditem.FoodItemId = Convert.ToDecimal(rdr["FoodItemId"]);
                    fooditem.FoodName = rdr["FoodName"].ToString();
                    fooditem.FoodGroupId = Convert.ToDecimal(rdr["FoodGroupId"]);
                    fooditem.FoodCost = Convert.ToDecimal(rdr["FoodCost"].ToString());
                    fooditem.FoodWeightTypeId = Convert.ToDecimal(rdr["FoodWeightTypeId"]);
                    fooditem.SellerId = Convert.ToDecimal(rdr["SellerId"]);
                    fooditem.QuantityAvailable = Convert.ToInt32(rdr["QuantityAvailable"]);
                    fooditem.SubFoodGroupId = Convert.ToDecimal(rdr["SubFoodGroupId"]);
                    fooditem.FoodPicture = rdr["FoodPicture"].ToString();
                    fooditem.AlternateText = rdr["AlternateText"].ToString();
                    fooditems.Add(fooditem);
                }
                rdr.Dispose();

            }
            }

            var DistinctItems = fooditems.GroupBy(x => x.FoodItemId).Select(y => y.First());

            return DistinctItems;

        }

        public void AddEnquiryToDB(ContactUs employee)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spAddEnquiryToDB", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodName = new SqlParameter();
                paramFoodName.ParameterName = "@Comment";
                paramFoodName.Value = employee.Comment;
                cmd.Parameters.Add(paramFoodName);

                SqlParameter paramFoodGrpId = new SqlParameter();
                paramFoodGrpId.ParameterName = "@Email";
                paramFoodGrpId.Value = employee.Email;
                cmd.Parameters.Add(paramFoodGrpId);

                SqlParameter paramFoodCost = new SqlParameter();
                paramFoodCost.ParameterName = "@FirstName";
                paramFoodCost.Value = employee.FirstName;
                cmd.Parameters.Add(paramFoodCost);

                SqlParameter paramFoodWeigth = new SqlParameter();
                paramFoodWeigth.ParameterName = "@LastName";
                paramFoodWeigth.Value = employee.LastName;
                cmd.Parameters.Add(paramFoodWeigth);

                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public bool ConfirmEmailIsUnique(string email)
        {
            string result = null;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spUniqueEmail", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramFoodGrpId = new SqlParameter();
                paramFoodGrpId.ParameterName = "@Email";
                paramFoodGrpId.Value=email;
                cmd.Parameters.Add(paramFoodGrpId);
                con.Open();
                cmd.ExecuteNonQuery();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    result = rdr["CustomerName"].ToString();
                }
                rdr.Dispose();

            }
            if(result == null || result ==""){
                return false;
            }
            else {
                return true;
            }
            
        }

        public string GetPasswordForThisEmail(string email)
        {
            String Password = null;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("spGetPassowrdForemail", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramEmail = new SqlParameter();
                paramEmail.ParameterName = "@Email";
                paramEmail.Value = email;
                cmd.Parameters.Add(paramEmail);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Password = (rdr["password"].ToString());
                    
                }
                rdr.Dispose();
            }
            return Password;
        }
        
        //public IEnumerable<CustomerDetail> CustomerDetails
        //{
        //    get
        //    {
        //        string connectionString =
        //            ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        //        List<CustomerDetail> Customers = new List<CustomerDetail>();

        //        using (SqlConnection con = new SqlConnection(connectionString))
        //        {
        //            SqlCommand cmd = new SqlCommand("spGetAllCustomerDetails", con);
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            con.Open();
        //            SqlDataReader rdr = cmd.ExecuteReader();
        //            while (rdr.Read())
        //            {
        //                CustomerDetail customer = new CustomerDetail();
        //                customer.Address =(rdr["Address"].ToString());
        //                customer.DateCreated = Convert.ToDateTime(rdr["DateCreated"].ToString());
        //                customer.Email = rdr["Email"].ToString();
        //                customer.FirstName = rdr["FirstName"].ToString();
        //                customer.LastName = rdr["LastName"].ToString();
        //                customer.password = rdr["password"].ToString();
        //                customer.Phone = rdr["Phone"].ToString();
        //                customer.StateId = Convert.ToDecimal(rdr["StateId"]);
        //                customer.Username = rdr["Username"].ToString();
        //                Customers.Add(customer);
        //            }
        //            rdr.Dispose();
        //        }

        //        return Customers;
        //    }
        //}
        //public void AddCustomerDetailToDB(CustomerDetail customer)
        //{
        //    string connectionString =
        //            ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        //    using (SqlConnection con = new SqlConnection(connectionString))
        //    {
        //        SqlCommand cmd = new SqlCommand("spAddCustomerDetail", con);
        //        cmd.CommandType = CommandType.StoredProcedure;

        //        SqlParameter paramUsername = new SqlParameter();
        //        paramUsername.ParameterName = "@Username";
        //        paramUsername.Value = customer.Username;
        //        cmd.Parameters.Add(paramUsername);

        //        SqlParameter parampassword = new SqlParameter();
        //        parampassword.ParameterName = "@password";
        //        parampassword.Value = customer.password;
        //        cmd.Parameters.Add(parampassword);

        //        SqlParameter paramFirstName = new SqlParameter();
        //        paramFirstName.ParameterName = "@FirstName";
        //        paramFirstName.Value = customer.FirstName;
        //        cmd.Parameters.Add(paramFirstName);

        //        SqlParameter paramLastName = new SqlParameter();
        //        paramLastName.ParameterName = "@LastName";
        //        paramLastName.Value = customer.LastName;
        //        cmd.Parameters.Add(paramLastName);

        //        SqlParameter paramAddress = new SqlParameter();
        //        paramAddress.ParameterName = "@Address";
        //        paramAddress.Value = customer.Address;
        //        cmd.Parameters.Add(paramAddress);

        //        SqlParameter paramStateId = new SqlParameter();
        //        paramStateId.ParameterName = "@StateId";
        //        paramStateId.Value = customer.StateId;
        //        cmd.Parameters.Add(paramStateId);

        //        SqlParameter paramPhone = new SqlParameter();
        //        paramPhone.ParameterName = "@Phone";
        //        paramPhone.Value = customer.Phone;
        //        cmd.Parameters.Add(paramPhone);

        //        SqlParameter paramEmail = new SqlParameter();
        //        paramEmail.ParameterName = "@Email";
        //        paramEmail.Value = customer.Email;
        //        cmd.Parameters.Add(paramEmail);

        //        con.Open();
        //        cmd.ExecuteNonQuery();
        //    }

        //}

        //public IEnumerable<FoodItem> StoreCarts()
        //{
        //    get
        //    {
        //        string connectionString =
        //            ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        //        List<FoodItem> StoreCarts = new List<FoodItem>();

        //        using (SqlConnection con = new SqlConnection(connectionString))
        //        {
        //            SqlCommand cmd = new SqlCommand("spGetAllFoodItems", con);
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            con.Open();
        //            SqlDataReader rdr = cmd.ExecuteReader();
        //            while (rdr.Read())
        //            {
        //                FoodItem fooditem = new FoodItem();
        //                fooditem.FoodItemId = Convert.ToDecimal(rdr["FoodItemId"]);
        //                fooditem.FoodName = rdr["FoodName"].ToString();
        //                fooditem.FoodGroupId = Convert.ToDecimal(rdr["FoodGroupId"]);
        //                fooditem.FoodCost = Convert.ToDecimal(rdr["FoodCost"].ToString());
        //                fooditem.FoodWeightTypeId = Convert.ToDecimal(rdr["FoodWeightTypeId"]);
        //                fooditem.SellerId = Convert.ToDecimal(rdr["SellerId"]);
        //                fooditem.QuantityAvailable = Convert.ToInt32(rdr["QuantityAvailable"]);
        //                fooditem.SubFoodGroupId = Convert.ToDecimal(rdr["SubFoodGroupId"]);
        //                fooditem.FoodPicture = rdr["FoodPicture"].ToString();
        //                fooditem.AlternateText = rdr["AlternateText"].ToString();
        //                StoreCarts.Add(fooditem);
        //            }
        //            rdr.Dispose();
        //        }

        //        return StoreCarts;
        //    }
        //}

        //public void AddCustomerOrderToDB(StoreCart store)
        //{
        //    string connectionString =
        //            ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        //    using (SqlConnection con = new SqlConnection(connectionString))
        //    {
        //        SqlCommand cmd = new SqlCommand("spAddCartItems", con);
        //        cmd.CommandType = CommandType.StoredProcedure;

        //        SqlParameter paramStoreCartId = new SqlParameter();
        //        paramStoreCartId.ParameterName = "@StoreCartId";
        //        paramStoreCartId.Value = store.StoreCartId;
        //        cmd.Parameters.Add(paramStoreCartId);

        //        SqlParameter paramFoodItemId = new SqlParameter();
        //        paramFoodItemId.ParameterName = "@FoodItemId";
        //        paramFoodItemId.Value = store.FoodItemId;
        //        cmd.Parameters.Add(paramFoodItemId);

        //        SqlParameter paramCount = new SqlParameter();
        //        paramCount.ParameterName = "@Count";
        //        paramCount.Value = store.Count;
        //        cmd.Parameters.Add(paramCount);

        //        con.Open();
        //        cmd.ExecuteNonQuery();
        //    }

        //}


    }
}
