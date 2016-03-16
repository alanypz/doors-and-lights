using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace City_Of_Orlando_Automated_Controller
{

    public class User
    {

        public User(string email, string password)
        {
            this.email = email;
            this.password = password;
        }

        public string email { get; set; }
        public string password { get; set; }
        public string token { get; set; }

    }
}
