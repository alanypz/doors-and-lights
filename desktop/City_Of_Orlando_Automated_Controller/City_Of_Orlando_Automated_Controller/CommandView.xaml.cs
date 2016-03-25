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
using System.ComponentModel;
using System.Threading;

namespace City_Of_Orlando_Automated_Controller
{
    /// <summary>
    /// Interaction logic for CommandView.xaml
    /// </summary>
    public partial class CommandView : ModernDialog
    {
        //Represents the string data of the referenced component
        private static Component componentData;

        public CommandView(Component componentData, string data)
        {
            InitializeComponent();
            
            // define the dialog buttons
            this.Buttons = new Button[] { this.CancelButton };

            // define title
            Title = "Command View";

            // define component status
            componentStatus.Text = data;
            CommandView.componentData = componentData;
        }

        private void Raise_Click(object sender, RoutedEventArgs e)
        {
            BackgroundWorker bw = new BackgroundWorker();
            string type = componentData.type.ToLower();
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

                if((bool)lr["success"])
                {
                    bw.DoWork += commandResult;
                    bw.RunWorkerCompleted += new RunWorkerCompletedEventHandler(complete);
                    bw.WorkerSupportsCancellation = true;
                    bw.RunWorkerAsync(type);

                } 
            }
            Close();
        }

        private void Lower_Click(object sender, RoutedEventArgs e)
        {
            BackgroundWorker bw = new BackgroundWorker();
            string type = componentData.type;
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/" + type.ToLower() + "s/lower");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            string data = "{\"" + type.ToLower() + "\":1}";

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

                if ((bool)lr["success"])
                {
                    bw.DoWork += commandResult;
                    bw.RunWorkerCompleted += new RunWorkerCompletedEventHandler(complete);
                    bw.WorkerSupportsCancellation = true;
                    bw.RunWorkerAsync(type);
                }

            }

            Close();
        }

        private static void commandResult(object sender, DoWorkEventArgs eventArgs)
        {
            int counter = 0;

            var serializer = new JavaScriptSerializer();

            while (counter < 5)
            {
                var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/" + componentData.type.ToLower());
                WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
                httpWebRequest.ContentType = "application/json";
                myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
                myWebHeaderCollection.Add(componentData.type.ToLower() + ":" + componentData.number);
                httpWebRequest.Method = "GET";

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

                var streamReader = new StreamReader(httpResponse.GetResponseStream());
                
                var result = streamReader.ReadToEnd();

                Dictionary<string, object> lr = serializer.Deserialize<dynamic>(result);

                if(((string)lr["position"] != Utility.components[Utility.componentIndex].position))
                {
                    Utility.components[Utility.componentIndex].position = (string)lr["position"];
                    break;
                }

                Thread.Sleep(1000);
                ++counter;
            }
        }

        private static void complete(object sender, RunWorkerCompletedEventArgs eventArgs)
        {
            Utility.componentButtons[Utility.componentIndex].Background = Brushes.LightGreen;
        }
    }
}
