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
        public CommandView(string data)
        {
            InitializeComponent();
            
            // define the dialog buttons
            this.Buttons = new Button[] { this.CancelButton };

            // define title
            Title = "Command View";

            // define component status
            componentStatus.Text = data;
        }

        private void Raise_Click(object sender, RoutedEventArgs e)
        {
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/doors/raise");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            //var serializedResult = serializer.Serialize("");
            string data = "{\"door\":1}";

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                //streamWriter.Write(serializedResult);
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

        private void Lower_Click(object sender, RoutedEventArgs e)
        {
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/doors/lower");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            //var serializedResult = serializer.Serialize("");
            string data = "{\"door\":1}";

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                //streamWriter.Write(serializedResult);
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
