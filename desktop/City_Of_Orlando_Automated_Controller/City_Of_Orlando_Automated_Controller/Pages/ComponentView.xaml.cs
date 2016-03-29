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
using FirstFloor.ModernUI.Windows.Controls;
using System.Windows.Resources;
using System.Threading;

namespace City_Of_Orlando_Automated_Controller.Pages
{
    /// <summary>
    /// Interaction logic for ComponentView.xaml
    /// </summary>
    public partial class ComponentView : UserControl
    {

        public ComponentView()
        {
            // init for the page
            InitializeComponent();

            // init for the doors/lights
            initializeComponents();

            // init refresh
            initializeRefresh();
        }

        void initializeComponents()
        {
            //Get the doors
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/door");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:door");
            var serializer = new JavaScriptSerializer();
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();
                
                Utility.lrDoors = serializer.Deserialize<dynamic>(result);
                
                for(int i=0; i<Utility.lrDoors.Length; i++)
                {
                    Utility.lrDoors[i] = serializer.Serialize(Utility.lrDoors[i]);
                }
            }

            //Get the lights
            httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/light");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:light");
            httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Utility.lrLights = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < Utility.lrLights.Length; i++)
                {
                    Utility.lrLights[i] = serializer.Serialize(Utility.lrLights[i]);
                }
            }

            //Put them together
            Utility.components = new Component[Utility.lrDoors.Length + Utility.lrLights.Length];
            Utility.componentButtons = new Button[Utility.lrDoors.Length + Utility.lrLights.Length];
            
            for(int i=0; i< Utility.lrDoors.Length + Utility.lrLights.Length; i++)
            {
                if(i<Utility.lrDoors.Length)
                {
                    Utility.components[i] = serializer.Deserialize<Component>(Utility.lrDoors[i].ToString());
                    Utility.components[i].type = "Door";
                }

                else
                {
                    Utility.components[i] = serializer.Deserialize<Component>(Utility.lrLights[i - Utility.lrDoors.Length].ToString());
                    Utility.components[i].type = "Light";
                }
 
                Button newComponent = new Button();
                Thickness margin = newComponent.Margin;
                margin.Left = 5;
                margin.Right = 5;
                margin.Top = 9;

                Uri resourceUri = null;

                if (i < Utility.lrDoors.Length)
                {
                    newComponent.Content = (i + 1).ToString();
                    newComponent.Tag = "Door";
                    resourceUri = new Uri("Images/garage.png", UriKind.Relative);
                }

                else
                {
                    newComponent.Content = (i + 1 - Utility.lrDoors.Length).ToString();
                    newComponent.Tag = "Light";
                    resourceUri = new Uri("Images/light.png", UriKind.Relative);
                }

                var brush = new ImageBrush();
                StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                brush.ImageSource = temp;
                newComponent.HorizontalAlignment = HorizontalAlignment.Left;
                newComponent.VerticalAlignment = VerticalAlignment.Top;
                newComponent.HorizontalContentAlignment = HorizontalAlignment.Center;
                newComponent.VerticalContentAlignment = VerticalAlignment.Top;
                newComponent.Width = 60;
                newComponent.Height = 60;
                newComponent.Margin = margin;
                newComponent.Background = brush;
                newComponent.AddHandler(Button.ClickEvent, new RoutedEventHandler(button_Click));
                Utility.componentButtons[i] = newComponent;

                if(Utility.doorBrush == null && Utility.components[i].type.ToLower() == "door")
                {
                    Utility.doorBrush = new ImageBrush();
                    Utility.doorBrush = brush;
                }

                if(Utility.lightBrush == null && Utility.components[i].type.ToLower() == "light")
                {
                    Utility.lightBrush = new ImageBrush();
                    Utility.lightBrush = brush;
                }

                if (i < Utility.lrDoors.Length)
                {
                    wpLight.Children.Add(newComponent);
                }

                else
                {
                    wpDoor.Children.Add(newComponent);
                }
            }

           
        }

        void initializeRefresh()
        {
            var brush = new ImageBrush();
            Uri resourceUri = new Uri("Images/refresh.png", UriKind.Relative);
            StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
            BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
            brush.ImageSource = temp;
            refresh.Background = brush;
        }

        void button_Click(object sender, EventArgs e)
        {

            resetButtons();

            Button selectedComponent = (Button)sender;

            Utility.componentIndex = Int32.Parse(selectedComponent.Content.ToString()) - 1;

            if((string)selectedComponent.Tag == "Light")
            {
                Utility.componentIndex += Utility.lrDoors.Length;
            }

            selectedComponent = Utility.componentButtons[Utility.componentIndex];

            Component component = Utility.components[Utility.componentIndex];

            string data =
                    "Type:" + component.type + "\n" +
                    "Number: " + component.number.ToString() + "\n" +
                    "Position: " + component.position.ToString() + "\n" +
                    "Status: " + component.state + "\n"
                ;

            ModernDialog commandView = new CommandView(component, data);
            commandView.Buttons = new Button[] { commandView.CancelButton };
            commandView.ShowDialog();
            
        }

        void resetButtons()
        {
            for (int i = 0; i < Utility.components.Length; i++)
            {
                if (Utility.components[i].type.ToLower() == "door")
                {
                    Utility.componentButtons[i].Background = Utility.doorBrush;
                }

                else
                {
                    Utility.componentButtons[i].Background = Utility.lightBrush;
                }
            }
        }

        private void refresh_Click(object sender, RoutedEventArgs e)
        {

            refresh.Cursor = Cursors.Wait;

            //Get the doors
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/door");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:door");
            var serializer = new JavaScriptSerializer();
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Utility.lrDoors = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < Utility.lrDoors.Length; i++)
                {
                    Utility.lrDoors[i] = serializer.Serialize(Utility.lrDoors[i]);
                }
            }

            //Get the lights
            httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/light");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:light");
            httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Utility.lrLights = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < Utility.lrLights.Length; i++)
                {
                    Utility.lrLights[i] = serializer.Serialize(Utility.lrLights[i]);
                }
            }

            //Put them together
            for (int i = 0; i < Utility.lrDoors.Length + Utility.lrLights.Length; i++)
            {
                if (i < Utility.lrDoors.Length)
                {
                    Utility.components[i] = serializer.Deserialize<Component>(Utility.lrDoors[i].ToString());
                    Utility.components[i].type = "Door";
                }

                else
                {
                    Utility.components[i] = serializer.Deserialize<Component>(Utility.lrLights[i - Utility.lrDoors.Length].ToString());
                    Utility.components[i].type = "Light";
                }
            }

            ModernDialog.ShowMessage("Components Successfully Updated", "Update", MessageBoxButton.OK, null);
            resetButtons();
        }

        private void refresh_MouseEnter(object sender, MouseEventArgs e)
        {
            refresh.Cursor = Cursors.Hand;
        }

        private void refresh_MouseLeave(object sender, MouseEventArgs e)
        {
            refresh.Cursor = Cursors.Arrow;
        }
    }
}
