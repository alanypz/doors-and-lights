using FirstFloor.ModernUI.Windows.Controls;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace City_Of_Orlando_Automated_Controller
{
    /// <summary>
    /// Interaction logic for Signup.xaml
    /// </summary>
    public partial class Signup : ModernDialog
    {
        public Signup()
        {
            InitializeComponent();

            // define the dialog buttons
            this.Buttons = new Button[] { this.CancelButton };
        }

        private void submit_Click(object sender, RoutedEventArgs e)
        {
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/signup");
            httpWebRequest.ContentType = "application/json";
            httpWebRequest.Method = "POST";

            string email = username.Text.ToString();
            string password = passwordBox.Password;
            User user = new User(email, password);
            username.Text = "";
            passwordBox.Password = "";
            firstname.Text = "";
            lastname.Text = "";

            var serializer = new JavaScriptSerializer();
            var serializedResult = serializer.Serialize(user);

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                streamWriter.Write(serializedResult);
                streamWriter.Flush();
                streamWriter.Close();
            }

            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Dictionary<string, object> lr = serializer.Deserialize<dynamic>(result);

                if (lr.ContainsValue(true))
                {
                    ModernDialog.ShowMessage("Successfully Created User", "", MessageBoxButton.OK);
                    Close();
                }

                else
                {
                    ModernDialog.ShowMessage("User Already Exists", "", MessageBoxButton.OK);
                }
            }
        }
    }
}
