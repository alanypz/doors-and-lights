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
using System.Windows.Resources;
using City_Of_Orlando_Automated_Controller.HelperClasses;
using City_Of_Orlando_Automated_Controller.Pages;

namespace City_Of_Orlando_Automated_Controller
{
    /// <summary>
    /// Interaction logic for CommandView.xaml
    /// </summary>
    public partial class CommandView : ModernDialog
    {
        //Represents the string data of the referenced component
        private static Component componentData;
        private static ComponentView loadingBar = null;
        private static CommandView view = null;
        private static BackgroundWorker bw = null;

        public CommandView(Component componentData, ComponentView componentView)
        {
            InitializeComponent();

            // define title
            Title = "Command View";

            // define component status
            componentStatus.Text = 
                    "Type:" + componentData.type + "\n" +
                    "Number: " + componentData.number.ToString() + "\n" +
                    "Position: " + componentData.position.ToString() + "\n" +
                    "Status: " + componentData.state + "\n"
                ;
            CommandView.componentData = componentData;
            view = this;

            loadingBar = componentView;

            if(componentData.state.ToLower() == "executing")
            {
                Raise.IsEnabled = false;
                Lower.IsEnabled = false;
            }

            if(componentData.position == "raised")
            {
                Raise.IsEnabled = false;
            }

            else if(componentData.position == "lowered")
            {
                Lower.IsEnabled = false;
            }

        }

        private void Raise_Click(object sender, RoutedEventArgs e)
        {
            bw = new BackgroundWorker();
            componentData.state = "executing";
            Raise.IsEnabled = false;
            Lower.IsEnabled = false;
            loadingBar.ShowPanelCommand.Execute(null);
            view.componentStatus.Text =
                    "Type:" + componentData.type + "\n" +
                    "Number: " + componentData.number.ToString() + "\n" +
                    "Position: " + componentData.position.ToString() + "\n" +
                    "Status: " + componentData.state + "\n"
                ;

            loadingBar.PanelMainMessage = "Raising " + componentData.type + " " + componentData.number;

            string type = componentData.type.ToLower();
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/" + type + "s/raise");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            string data = "{\"" + type + "\":" + componentData.number + "}";

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

        }

        private void Lower_Click(object sender, RoutedEventArgs e)
        {
            bw = new BackgroundWorker();
            componentData.state = "executing";
            Raise.IsEnabled = false;
            Lower.IsEnabled = false;
            loadingBar.ShowPanelCommand.Execute(null);
            view.componentStatus.Text =
                    "Type:" + componentData.type + "\n" +
                    "Number: " + componentData.number.ToString() + "\n" +
                    "Position: " + componentData.position.ToString() + "\n" +
                    "Status: " + componentData.state + "\n"
                ;

            loadingBar.PanelMainMessage = "Lowering " + componentData.type + " " + componentData.number;
    
            
            string type = componentData.type;
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/" + type.ToLower() + "s/lower");
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;

            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            string data = "{\"" + type.ToLower() + "\":" + componentData.number + "}";

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

        }

        private static void commandResult(object sender, DoWorkEventArgs eventArgs)
        {
            int counter = 0;
            
            var serializer = new JavaScriptSerializer();

            while (counter < 5)
            {
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/status/" + componentData.type.ToLower());
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
                    Utility.components[Utility.componentIndex].state = (string)lr["state"];
                    break;
                }

                Thread.Sleep(6000);
                ++counter;

                if(bw.CancellationPending)
                {
                    eventArgs.Cancel = true;
                    break;
                }
            }

            if (counter > 5)
            {
                
                Uri resourceUri = null;

                Application.Current.Dispatcher.Invoke((Action)(() =>
                {
                    if (componentData.type.ToLower() == "door")
                    {
                        resourceUri = new Uri("Images/garage_error.png", UriKind.Relative);
                        ImageBrush brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[Utility.componentIndex].Background = brush;
                    }

                    else
                    {
                        resourceUri = new Uri("Images/light_error.png", UriKind.Relative);
                        ImageBrush brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[Utility.componentIndex].Background = brush;
                    }

                    loadingBar.HidePanelCommand.Execute(null);
                    loadingBar.refresh.IsEnabled = true;

                }));

                bw.RunWorkerCompleted -= complete;
            }

        }

        private static void complete(object sender, RunWorkerCompletedEventArgs eventArgs)
        {
            Uri resourceUri = null;

            Application.Current.Dispatcher.Invoke((Action)(() =>
            {
                if (componentData.type.ToLower() == "door")
                {
                    if (componentData.position == "raised")
                    {
                        resourceUri = new Uri("Images/garage_raised.png", UriKind.Relative);
                        ImageBrush brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[Utility.componentIndex].Background = brush;
                        view.Raise.IsEnabled = false;
                        view.Lower.IsEnabled = true;
                    }

                    else
                    {
                        resourceUri = new Uri("Images/garage_lowered.png", UriKind.Relative);
                        var brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[Utility.componentIndex].Background = brush;
                        view.Lower.IsEnabled = false;
                        view.Raise.IsEnabled = true;
                    }
                }

                else
                {
                    if (componentData.position == "raised")
                    {
                        resourceUri = new Uri("Images/light_raised.png", UriKind.Relative);
                        ImageBrush brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[Utility.componentIndex].Background = brush;
                        view.Raise.IsEnabled = false;
                        view.Lower.IsEnabled = true;
                    }

                    else
                    {
                        resourceUri = new Uri("Images/light_lowered.png", UriKind.Relative);
                        var brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[Utility.componentIndex].Background = brush;
                        view.Lower.IsEnabled = false;
                        view.Raise.IsEnabled = true;
                    }
                }

                view.componentStatus.Text =
                    "Type:" + componentData.type + "\n" +
                    "Number: " + componentData.number.ToString() + "\n" +
                    "Position: " + componentData.position + "\n" +
                    "Status: " + componentData.state + "\n"
                ;

                loadingBar.refresh.IsEnabled = true;
                loadingBar.PanelSubMessage = componentData.type.ToUpper() + " " + componentData.number.ToString().ToUpper() + " " + componentData.position.ToUpper();

                Timer timer = null;
                timer = new System.Threading.Timer((obj) =>
                {
                    Application.Current.Dispatcher.Invoke((Action)(() =>
                    {
                        loadingBar.HidePanelCommand.Execute(null);
                        loadingBar.PanelSubMessage = "";
                        loadingBar.PanelMainMessage = "";
                        loadingBar.enableButtons();
                    }));
                    
                    timer.Dispose();
                },
                null, 2000, System.Threading.Timeout.Infinite);

            }));

        }

        private void Stop_Click(object sender, RoutedEventArgs e)
        {
            bw.CancelAsync();
        }
    }
}
