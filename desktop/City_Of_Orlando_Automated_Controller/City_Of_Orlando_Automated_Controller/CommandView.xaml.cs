using FirstFloor.ModernUI.Windows.Controls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using System.Net.Http;

namespace City_Of_Orlando_Automated_Controller
{
    /// <summary>
    /// Interaction logic for CommandView.xaml
    /// </summary>
    public partial class CommandView : ModernDialog
    {
        //Represents the string data of the referenced component
        private string component;

        public CommandView(string data)
        {
            InitializeComponent();
            
            // define the dialog buttons
            this.Buttons = new Button[] { this.CancelButton };

            // define title
            Title = "Command View";

            // define component status
            componentStatus.Text = data;
            component = data;
        }

        private void Raise_Click(object sender, RoutedEventArgs e)
        {
            string type = component.Contains("Door") ? "door" : "light";
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/" + type + "s/raise");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            string data = "{\"" + type + "\":1}";

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                streamWriter.Write(data);
                streamWriter.Flush();
                streamWriter.Close();
            }

            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Dictionary<string, object> lr = serializer.Deserialize<dynamic>(result);

                if((string)lr["success"] == "true")
                {

                }
                

                
            }
        }

        private void Lower_Click(object sender, RoutedEventArgs e)
        {
            string type = component.Contains("Door") ? "door" : "light";
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/" + type + "s/lower");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            string data = "{\"" + type + "\":1}";

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                streamWriter.Write(data);
                streamWriter.Flush();
                streamWriter.Close();
            }

            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Dictionary<string, object> lr = serializer.Deserialize<dynamic>(result);



            }
        }
    }
}
