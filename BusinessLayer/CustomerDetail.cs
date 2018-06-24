using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class CustomerDetail
    {
        [Key]
        public decimal CustomerDetailId { get; set; }
        public string Username { get; set; }
        [Required]
        public string password { get; set; }
        [Required(ErrorMessage = "First Name is Required")]
        [DisplayName("First Name")]
        public string FirstName { get; set; }
        [Required(ErrorMessage = "Last Name is Required")]
        [DisplayName("Last Name")]
        public string LastName { get; set; }
        [Required(ErrorMessage = "Address is Required")]
        [DataType(DataType.MultilineText)]
        public string Address { get; set; }
        [DisplayName("State")]
        public decimal StateId { get; set; }
        [Required(ErrorMessage = "Phone is Required")]
        [RegularExpression(@"[0-9]{11}", ErrorMessage = "Phone Number not complete or correct")]
        public string Phone { get; set; }
        [Required(ErrorMessage = "Email is Required")]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}", ErrorMessage = "Email is not Valid")]
        public string Email { get; set; }
        public decimal Total { get; set; }

        public System.DateTime? DateCreated { get; set; }
        public List<CustomerOrderDetail> CustomerOrderDetails { get; set; }
        public List<State> States { get; set; }

    }
}
